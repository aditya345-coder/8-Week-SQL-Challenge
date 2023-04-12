CREATE SCHEMA dannys_diner;
-- SET search_path = dannys_diner;

USE dannys_diner;
CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
-- Solution

-- 1. What is the total amount each customer spent at the restaurant?
SELECT 
	  s.customer_id, 
    SUM(m.price) AS total_amount 
FROM sales s
JOIN menu m ON s.product_id=m.product_id
GROUP BY s.customer_id;

-- 2. How many days has each customer visited the restaurant?
SELECT 
    customer_id,
    COUNT(DISTINCT order_date) AS no_times_visited
FROM sales 
GROUP BY customer_id;

-- DISTINCT is used here, because if a customer visited the restaurant multiple times on the same day and placed multiple orders, 
-- each of those orders would be counted separately as a visit, leading to an inflated count.
  
  
-- 3. What was the first item from the menu purchased by each customer?
SELECT customer_id, 
	   product_name  
FROM (SELECT s.customer_id, 
             m.product_name, 
			 ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rnk
FROM sales s
JOIN menu m ON m.product_id = s.product_id) AS t
WHERE t.rnk=1;


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT m.product_name,COUNT(*) AS most_purchased
FROM sales s
JOIN menu m ON s.product_id=m.product_id
GROUP BY m.product_name
ORDER BY most_purchased DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?
WITH cte AS (SELECT s.customer_id, 
		    m.product_name, 
                    COUNT(s.product_id) AS count,
                    DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(s.product_id) DESC ) AS rnk
FROM sales s
JOIN menu m ON s.product_id=m.product_id
GROUP BY s.customer_id, m.product_id)

SELECT customer_id, 
       product_name, 
       count,rnk  
FROM cte
WHERE rnk=1;
