#!/bin/bash

sudo docker build -t ingest_py:v02 .

#URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-01.csv.gz"
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz"
#ZONE_URL="https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv"

sudo docker run -it \
  --network=pg_network \
  ingest_py:v02 \
  --user=root \
  --password=root \
  --host=pg_database \
  --port=5432 \
  --db=ny_taxi \
  --table_name=green_taxi_trips \
  --csv_url=${URL} #\
 # --zone_csv_url=${ZONE_URL}
