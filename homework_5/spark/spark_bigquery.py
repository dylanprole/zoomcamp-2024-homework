#!/usr/bin/env python
# coding: utf-8


# Import libraries
import argparse

import pyspark
from pyspark.sql import SparkSession
from pyspark.sql import types
from pyspark.sql import functions as F

parser = argparse.ArgumentParser()

parser.add_argument('--input_green', required=True)
parser.add_argument('--input_yellow', required=True)
parser.add_argument('--output', required=True)

args = parser.parse_args()

input_green = args.input_green
input_yellow = args.input_yellow
output = args.output

# Connect to local cluster at port 8080
spark = SparkSession.builder \
    .appName('test') \
    .getOrCreate()

# Use the Cloud Storage bucket for temporary BigQuery export data used
# by the connector.
bucket = 'dataproc-temp-au-southeast1-275129653963-edj7mq7t'
spark.conf.set('temporaryGcsBucket', bucket)

# df_green = spark.read.parquet('../data/pq/green/*/*')
df_green = spark.read.parquet(input_green)

df_green_rename = df_green \
    .withColumnRenamed('lpep_pickup_datetime', 'pickup_datetime') \
    .withColumnRenamed('lpep_dropoff_datetime', 'dropoff_datetime') \
    .withColumnRenamed('PULocationID', 'pickup_id') \
    .withColumnRenamed('DOLocationID', 'dropoff_id') \
    .withColumnRenamed('RatecodeID', 'ratecode_id') \
    .withColumnRenamed('VendorID', 'vendor_id')

df_yellow = spark.read.parquet(input_yellow)

df_yellow_rename = df_yellow \
    .withColumnRenamed('tpep_pickup_datetime', 'pickup_datetime') \
    .withColumnRenamed('tpep_dropoff_datetime', 'dropoff_datetime') \
    .withColumnRenamed('PULocationID', 'pickup_id') \
    .withColumnRenamed('DOLocationID', 'dropoff_id') \
    .withColumnRenamed('RatecodeID', 'ratecode_id') \
    .withColumnRenamed('VendorID', 'vendor_id')

common_cols = list()

yellow_cols = set(df_yellow_rename.columns)

for col in df_green_rename.columns:
    if col in yellow_cols:
        common_cols.append(col)

df_green_sel = df_green_rename \
    .select(common_cols) \
    .withColumn('service_type', F.lit('green'))

df_yellow_sel = df_yellow_rename \
    .select(common_cols) \
    .withColumn('service_type', F.lit('yellow'))

df_trips_data = df_green_sel.unionAll(df_yellow_sel)

df_trips_data.groupBy('service_type').count().show()

df_trips_data.createOrReplaceTempView('trips_data')

df_result = spark.sql("""
    SELECT 
        -- Revenue grouping 
        pickup_id AS revenue_zone,
        DATE_TRUNC('month', pickup_datetime) AS revenue_month, 
        service_type, 

        -- Revenue calculation 
        SUM(fare_amount) AS revenue_monthly_fare,
        SUM(extra) AS revenue_monthly_extra,
        SUM(mta_tax) AS revenue_monthly_mta_tax,
        SUM(tip_amount) AS revenue_monthly_tip_amount,
        SUM(tolls_amount) AS revenue_monthly_tolls_amount,
        SUM(improvement_surcharge) AS revenue_monthly_improvement_surcharge,
        SUM(total_amount) AS revenue_monthly_total_amount,

        -- Additional calculations
        AVG(passenger_count) AS avg_monthly_passenger_count,
        AVG(trip_distance) AS avg_monthly_trip_distance

    FROM 
        trips_data
    GROUP BY
        revenue_zone,
        revenue_month,
        service_type
""")

# Save the data to BigQuery
df_result.write.format('bigquery') \
    .option('table', output) \
    .save()
