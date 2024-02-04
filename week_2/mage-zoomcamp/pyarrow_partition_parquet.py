import os
import pyarrow as pa
import pyarrow.parquet as pq

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

os.environ['GOOGLE_APPLICATION_CREDENDIALS'] = "/home/src/.keys/mage_zoomcamp_sa.json"

bucket_name = 'taxi-rides-ny-412407-mage'
project_id = 'taxi-rides-ny-412407'

table_name = 'nyc_taxi_data'

root_path = f'{bucket_name}/{table_name}'

@data_exporter
def export_data(data, *args, **kwargs):
    print(type(data))
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date

    table = pa.Table.from_pandas(data)

    gcs = pa.fs.GcsFileSystem()

    pq.write_to_dataset(
        table=table,
        root_path=root_path,
        partition_cols=['lpep_pickup_date'],
        filesystem=gcs
    )