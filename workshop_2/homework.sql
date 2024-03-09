-- Question 1
create materialized view

trip_time_stats as

    with

    trip_times as (
        
        select
            pick_up.zone as pickup_zone,
            drop_off.zone as dropoff_zone,
            trip_data.tpep_pickup_datetime,
            trip_data.tpep_dropoff_datetime,
            trip_data.tpep_dropoff_datetime - trip_data.tpep_pickup_datetime as trip_time
        
        from trip_data
        
        inner join taxi_zone as pick_up
            on trip_data.PULocationID = pick_up.location_id
        
        inner join taxi_zone as drop_off
            on trip_data.DOLocationID = drop_off.location_id
    )

    select
        pickup_zone,
        dropoff_zone,
        avg(trip_time) as avg_trip_time,
        min(trip_time) as min_trip_time,
        max(trip_time) as max_trip_time

    from trip_times

    group by 1, 2
;

select * from trip_time_stats order by avg_trip_time desc limit 10;

-- Question 2
create materialized view

trip_time_stats_2 as

    with

    trip_times as (
        
        select
            pick_up.zone as pickup_zone,
            drop_off.zone as dropoff_zone,
            trip_data.tpep_pickup_datetime,
            trip_data.tpep_dropoff_datetime,
            trip_data.tpep_dropoff_datetime - trip_data.tpep_pickup_datetime as trip_time
        
        from trip_data
        
        inner join taxi_zone as pick_up
            on trip_data.PULocationID = pick_up.location_id
        
        inner join taxi_zone as drop_off
            on trip_data.DOLocationID = drop_off.location_id
    )

    select
        pickup_zone,
        dropoff_zone,
        avg(trip_time) as avg_trip_time,
        min(trip_time) as min_trip_time,
        max(trip_time) as max_trip_time,
        count(*) as trip_count

    from trip_times

    group by 1, 2
;

select * from trip_time_stats_2 order by avg_trip_time desc limit 10;

-- Question 3

with

t as (

    select
        max(tpep_pickup_datetime) as latest_pickup_time

    from trip_data

),

latest_pickups as (
        
    select
        pick_up.zone as pickup_zone,
        trip_data.tpep_pickup_datetime as pickup_time,
        t.latest_pickup_time as latest_pickup,
        t.latest_pickup_time - trip_data.tpep_pickup_datetime as time_before
        
    from t, trip_data

    inner join taxi_zone as pick_up
        on trip_data.PULocationID = pick_up.location_id

    where
        trip_data.tpep_pickup_datetime >= t.latest_pickup_time - interval '17 hours'
)

select
    pickup_zone,
    count(*) as trips_count

from latest_pickups

group by 1

order by 2 desc

limit 10

;