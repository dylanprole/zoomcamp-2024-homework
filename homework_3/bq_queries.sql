-- 0 Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `taxi-rides-ny-000000.nytaxi.external_green_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://taxi-rides-ny-000000-bigquery/green_tripdata_2022-*.parquet']
);

-- 0 Create a non partitioned table from external table
CREATE OR REPLACE TABLE taxi-rides-ny-000000.nytaxi.green_tripdata_non_partitoned AS
SELECT * FROM taxi-rides-ny-000000.nytaxi.external_green_tripdata;

------ Homework
---- 1 count for unpartitioned and unclustered table
SELECT COUNT(*) FROM taxi-rides-ny-000000.nytaxi.green_tripdata_non_partitoned;

---- 2 Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
-- Scan 0 B
SELECT COUNT(DISTINCT "PULocationIDs") FROM taxi-rides-ny-000000.nytaxi.external_green_tripdata;
-- Scan 0 B
SELECT COUNT(DISTINCT "PULocationIDs") FROM taxi-rides-ny-000000.nytaxi.green_tripdata_non_partitoned;

---- 3 How many records have a fare_amount of 0?
SELECT COUNT(*) FROM taxi-rides-ny-000000.nytaxi.green_tripdata_non_partitoned WHERE fare_amount = 0;

---- 4 What is the best strategy to make an optimized table in Big Query if your query will always order the 
---- results by PUlocationID and filter based on lpep_pickup_datetime?
-- Creating a partition and cluster table
CREATE OR REPLACE TABLE taxi-rides-ny-000000.nytaxi.green_tripdata_partitoned_clustered
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PULocationID AS
SELECT * FROM taxi-rides-ny-000000.nytaxi.external_green_tripdata;

---- 5 Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022
-- Non-partitioned - 12.82 MB
SELECT DISTINCT PULocationID
FROM taxi-rides-ny-000000.nytaxi.green_tripdata_non_partitoned
WHERE lpep_pickup_datetime BETWEEN '2022-06-01' AND '2022-06-30';
-- Partitioned - 1.12 MB
SELECT DISTINCT PULocationID
FROM taxi-rides-ny-000000.nytaxi.green_tripdata_partitoned_clustered
WHERE lpep_pickup_datetime BETWEEN '2022-06-01' AND '2022-06-30';
