python spark_submit_local.py \
    --input_green=../data/pq/green/2020/* \
    --input_yellow=../data/pq/yellow/2020/* \
    --output=../data/report/revenue_2020/


URL="spark://de-zoomcamp.australia-southeast1-b.c.taxi-rides-ny-412407.internal:7077"

spark-submit \
    --master="${URL}" \
    spark_submit_local.py \
        --input_green=../data/pq/green/2021/* \
        --input_yellow=../data/pq/yellow/2021/* \
        --output=../data/report/revenue_2021/

taxi-rides-ny-412407-bigquery

--input_green=gs://taxi-rides-ny-412407-bigquery/pq/green/2020/*/ \
--input_yellow=gs://taxi-rides-ny-412407-bigquery/pq/yellow/2020/*/ \
--output=gs://taxi-rides-ny-412407-bigquery/report_2020/

# Submit job to cluster with SDK
gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster \
    --region=australia-southeast1 \
    gs://taxi-rides-ny-412407-bigquery/python_files/spark_submit_local.py \
    -- \
        --input_green=gs://taxi-rides-ny-412407-bigquery/pq/green/2020/*/ \
        --input_yellow=gs://taxi-rides-ny-412407-bigquery/pq/yellow/2020/*/ \
        --output=gs://taxi-rides-ny-412407-bigquery/report_2020/