#!/usr/bin/env python
# coding: utf-8

import os
import re
import argparse
import psycopg2

import pandas as pd

from time import time
from subprocess import run
from sqlalchemy import create_engine, URL

def main(params):
    table_name = params.table_name
    
    csv_url = params.csv_url
    csv_name = re.search('[a-zA-Z0-9_\-]*.csv', csv_url).group()
    
    if csv_name not in os.listdir():
        run(['wget', csv_url], check=True)
        csv_gz_name = re.search('[a-zA-Z0-9_\-]*.csv.gz', csv_url).group()

        run(['gunzip', csv_gz_name], check=True)

    url_object = URL.create(
        "postgresql",
        username=params.user,
        password=params.password,
        host=params.host,
        database=params.db,
    )

    engine = create_engine(url_object)

    try:
        engine.connect()
        print('The database device is connected uh successfully~')
    except:
        print('Connection failed.')

    df_iter = pd.read_csv(csv_name, iterator=True, chunksize=50000)

    df = next(df_iter)

    df['lpep_pickup_datetime'] = pd.to_datetime(df['lpep_pickup_datetime'])
    df['lpep_dropoff_datetime'] = pd.to_datetime(df['lpep_dropoff_datetime'])

    df.head(0).to_sql(name=table_name, con=engine, if_exists='replace')

    df.to_sql(name=table_name, con=engine, if_exists='append')

    while True:
        t_start = time()

        df = next(df_iter)

        df['lpep_pickup_datetime'] = pd.to_datetime(df['lpep_pickup_datetime'])
        df['lpep_dropoff_datetime'] = pd.to_datetime(df['lpep_dropoff_datetime'])

        df.to_sql(name=table_name, con=engine, if_exists='append')

        t_end = time()

        print('Appended 50,000 lines in %.2f seconds' % (t_end - t_start))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest CSV to PostgreSQL.')

    parser.add_argument('--user', help='user for postgresql')
    parser.add_argument('--password', help='password for postgresql')
    parser.add_argument('--host', help='host for postgresql')
    parser.add_argument('--db', help='db name for postgresql')
    parser.add_argument('--port', help='db name for postgresql')
    parser.add_argument('--table_name', help='name of table we will write results to')
    parser.add_argument('--csv_url', help='url of csv for data')

    args = parser.parse_args()

    main(args)

