#!/bin/bash

sudo docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_db:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg_network \
  --name pg_database \
  postgres:13
