-- Question 3. Count records
	-- ANS = 15612
SELECT
	COUNT(*)
FROM
	green_taxi_trips
WHERE 1=1
	AND lpep_pickup_datetime::DATE = '2019-09-18'
	AND lpep_dropoff_datetime::DATE = '2019-09-18'
;
	
-- Question 4. Largest trip for each day
	-- ANS = "2019-09-26"
SELECT
	lpep_pickup_datetime::DATE
FROM
	green_taxi_trips
ORDER BY
	trip_distance DESC
LIMIT 1;

-- Question 5. Three biggest pick up Boroughs
	-- "Manhattan", "Brooklyn", "Queens"
SELECT
	pick_up."Borough"
FROM
	green_taxi_trips AS trips
LEFT JOIN
	zones AS pick_up
ON
	trips."PULocationID" = pick_up."LocationID"
WHERE
	lpep_pickup_datetime::DATE = '2019-09-18'
GROUP BY
	pick_up."Borough"
ORDER BY
	COUNT(*) DESC
LIMIT 3;

-- Question 6. Largest tip
	-- ANS = "JFK Airport"
SELECT
	drop_off."Zone"
FROM
	green_taxi_trips AS trips
LEFT JOIN
	zones AS pick_up
ON
	trips."PULocationID" = pick_up."LocationID"
LEFT JOIN
	zones AS drop_off
ON
	trips."DOLocationID" = drop_off."LocationID"
WHERE
	DATE_TRUNC('MONTH', lpep_pickup_datetime) = '2019-09-01'
AND
	pick_up."Zone" = 'Astoria'
ORDER BY
	tip_amount DESC
LIMIT 1;