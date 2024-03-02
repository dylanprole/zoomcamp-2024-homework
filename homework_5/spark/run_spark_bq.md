# Submit job to cluster with SDK
gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster \
    --region=australia-southeast1 \
    --jars=gs://spark-lib/bigquery/spark-bigquery-latest_2.12.jar \
    gs://taxi-rides-ny-412407-bigquery/python_files/spark_bigquery.py \
    -- \
        --input_green=gs://taxi-rides-ny-412407-bigquery/pq/green/2020/*/ \
        --input_yellow=gs://taxi-rides-ny-412407-bigquery/pq/yellow/2020/*/ \
        --output=nytaxi.reports-2020