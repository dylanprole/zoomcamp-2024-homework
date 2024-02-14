import io
import os
import requests
import pandas as pd
from subprocess import run
from google.cloud import storage

"""
Pre-reqs: 
1. `pip install pandas pyarrow google-cloud-storage`
2. Set GOOGLE_APPLICATION_CREDENTIALS to your project/service-account key
3. Set GCP_GCS_BUCKET as your bucket or change default value of BUCKET
"""

# services = ['fhv','green','yellow']
init_url = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/'
# switch out the bucketname
BUCKET = os.environ.get("GCP_GCS_BUCKET", "dtc-data-lake-bucketname")


def upload_to_gcs(bucket, object_name, local_file):
    """
    Ref: https://cloud.google.com/storage/docs/uploading-objects#storage-upload-object-python
    """
    # # WORKAROUND to prevent timeout for files > 6 MB on 800 kbps upload speed.
    # # (Ref: https://github.com/googleapis/python-storage/issues/74)
    # storage.blob._MAX_MULTIPART_SIZE = 5 * 1024 * 1024  # 5 MB
    # storage.blob._DEFAULT_CHUNKSIZE = 5 * 1024 * 1024  # 5 MB

    client = storage.Client()
    bucket = client.bucket(bucket)
    blob = bucket.blob(object_name)
    blob.upload_from_filename(local_file)


def web_to_gcs(year, service, taxi_dtypes, parse_dates):
    for i in range(12):
        
        # sets the month part of the file_name string
        month = '0'+str(i+1)
        month = month[-2:]

        # csv file_name
        file_name = f"{service}_tripdata_{year}-{month}.csv.gz"

        # download it using requests via a pandas df
        request_url = f"{init_url}{service}/{file_name}"
        r = requests.get(request_url)
        open(file_name, 'wb').write(r.content)
        print('Downloading files...')
        print(f"\tLocal: {file_name}")

        # read it back into a csv file
        df = pd.read_csv(file_name, sep=",", compression="gzip", dtype=taxi_dtypes, parse_dates=parse_dates)
        csv_gz_name=file_name
        file_name = file_name.replace('.csv.gz', '.csv')
        df.to_csv(file_name, index=False)
        print(f"\tCSV: {file_name}")

        # upload it to gcs 
        print('Uploading to Google Storage...')
        print(f"\tGCS: {service}/{file_name}")
        upload_to_gcs(BUCKET, f"{service}/{file_name}", file_name)

        # clean up files
        print('Cleaning up local files...')

        print(f'\tRemoving {csv_gz_name}')
        os.remove(csv_gz_name)

        print(f'\tRemoving {file_name}')
        os.remove(file_name)
        print()

# Data types
green_yellow_dtypes = {
    'VendorID': pd.Int64Dtype(), 'passenger_count': pd.Int64Dtype(), 'trip_distance': float,
    'RatecodeID': pd.Int64Dtype(), 'store_and_fwd_flag': str, 'PULocationID': pd.Int64Dtype(),
    'DOLocationID': pd.Int64Dtype(), 'payment_type': pd.Int64Dtype(), 'fare_amount': float,
    'extra': float, 'mta_tax': float, 'tip_amount': float, 'tolls_amount': float,
    'improvement_surcharge': float, 'total_amount': float, 'congestion_surcharge': float 
}

fhv_dtypes = {
    'dispatching_base_num': str, 'PULocationID': pd.Int64Dtype(),
    'DOLocationID': pd.Int64Dtype(), 'SR_Flag': pd.Int64Dtype(),
    'Affiliated_base_number': str
}

# Parse dates
green_dates = ['lpep_pickup_datetime', 'lpep_dropoff_datetime']
yellow_dates = ['tpep_pickup_datetime', 'tpep_dropoff_datetime']
fhv_dates = ['pickup_datetime', 'dropOff_datetime']

# Green
web_to_gcs('2019', 'green', green_yellow_dtypes, green_dates)
web_to_gcs('2020', 'green', green_yellow_dtypes, green_dates)

# Yellow
web_to_gcs('2019', 'yellow', green_yellow_dtypes, yellow_dates)
web_to_gcs('2020', 'yellow', green_yellow_dtypes, yellow_dates)

# Fhv
web_to_gcs('2019', 'fhv', fhv_dtypes, fhv_dates)