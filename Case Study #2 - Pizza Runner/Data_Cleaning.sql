USE pizza_runner;

-- Create a new temporary table: customer_orders_temp
DROP TABLE IF EXISTS customer_orders_temp;
CREATE TEMPORARY TABLE customer_orders_temp AS
	SELECT order_id,
		   customer_id,
		   pizza_id,
		   CASE
			   WHEN exclusions IS NULL THEN ''
			   WHEN exclusions = 'null' THEN ''
			   ELSE exclusions
		   END AS exclusions,
		   CASE
			   WHEN extras IS NULL THEN ''
			   WHEN extras = 'null' THEN ''
			   ELSE extras
		   END AS extras,
		   order_time
	FROM customer_orders;

SELECT * FROM customer_orders_temp;

-- Create a new temporary table: runner_orders_temp
DROP TABLE IF EXISTS runner_orders_temp;
CREATE TEMPORARY TABLE runner_orders_temp AS
	SELECT order_id,
		   runner_id,
		   CASE
			   WHEN pickup_time='null' OR pickup_time=''  THEN NULL
			   ELSE pickup_time
		   END AS pickup_time,
		   CASE
			   WHEN distance = 'null' OR distance='' THEN NULL
			   WHEN distance LIKE '%km' THEN TRIM(REPLACE(distance, 'km', ''))
			   ELSE distance
		   END AS distance,
		   CASE 
               WHEN duration = 'null' OR duration='' THEN NULL
			   WHEN duration LIKE '%min%' THEN SUBSTRING(duration, 1,2)
			   ELSE duration
		   END AS duration,
		   CASE 
			   WHEN cancellation IS NULL OR cancellation='null' THEN ''
			   ELSE cancellation
		   END AS cancellation
	FROM runner_orders;


-- Rename distance to distance_km
ALTER TABLE runner_orders_temp
RENAME COLUMN distance TO distance_km;
-- Rename duration to duration_min
ALTER TABLE runner_orders_temp
RENAME COLUMN duration TO duration_min;

-- Changing column datatype
ALTER TABLE runner_orders_temp
MODIFY COLUMN pickup_time DATETIME;

ALTER TABLE runner_orders_temp
MODIFY COLUMN distance_km FLOAT; 

ALTER TABLE runner_orders_temp
MODIFY COLUMN duration_min INT;

SELECT * FROM runner_orders_temp; 
