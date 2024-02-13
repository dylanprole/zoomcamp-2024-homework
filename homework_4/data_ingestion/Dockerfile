FROM python:3.9.1

ARG USER_CODE_PATH=/home/src/data_ingestion

COPY ./.keys/mage_zoomcamp_sa.json ${USER_CODE_PATH}/.keys/mage_zoomcamp_sa.json

ENV GOOGLE_APPLICATION_CREDENTIALS=${USER_CODE_PATH}/.keys/mage_zoomcamp_sa.json
ENV GCP_GCS_BUCKET=taxi-rides-ny-412407-bigquery

RUN apt-get install wget
RUN pip install requests pandas pyarrow google-cloud-storage

WORKDIR /app
COPY ingest_ny_taxi_parquet.py ingest_ny_taxi_parquet.py

ENTRYPOINT [ "python", "ingest_ny_taxi_parquet.py" ]