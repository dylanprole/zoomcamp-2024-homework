#!/bin/bash

sudo docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network=pg_network \
  --name pgadmin \
  dpage/pgadmin4
