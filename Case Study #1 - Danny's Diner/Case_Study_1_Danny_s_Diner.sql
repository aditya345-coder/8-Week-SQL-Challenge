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

-- 6. Which item was purchased first by the customer after they became a member?
WITH cte AS(
            SELECT s.customer_id,
                   m.product_name, 
                   mb.join_date, 
                   s.order_date, 
                   DENSE_RANK() OVER(PARTITION BY mb.customer_id ORDER BY s.order_date) AS rnk
            FROM sales s
            JOIN members mb ON mb.customer_id = s.customer_id
            JOIN menu m ON s.product_id=m.product_id
            WHERE s.order_date >= mb.join_date)

SELECT customer_id,
       product_name,
       order_date
FROM cte
WHERE rnk=1;

-- 7. Which item was purchased just before the customer became a member? # ERROR
WITH cte AS (
	SELECT s.customer_id,
	       m.product_name, 
	       mb.join_date, 
	       s.order_date, 
	       DENSE_RANK() OVER(PARTITION BY mb.customer_id ORDER BY s.order_date) AS rnk
	FROM sales s
	JOIN members mb ON mb.customer_id = s.customer_id
	JOIN menu m ON s.product_id=m.product_id
	WHERE s.order_date < mb.join_date
)

SELECT customer_id,
	   product_name
FROM cte
WHERE rnk=1;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id,
	   COUNT(m.product_name) AS number_of_item, 
       SUM(m.price) AS total_amount
FROM sales s
JOIN members mb ON mb.customer_id = s.customer_id
JOIN menu m ON s.product_id=m.product_id
WHERE s.order_date < mb.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
WITH cte AS(
	SELECT s.customer_id, 
	       m.product_name, 
               s.order_date, 
               CASE WHEN m.product_name='sushi' THEN ROUND(m.price*20,1) 
	       ELSE ROUND(m.price*10,1) 
               END AS points 
	FROM sales s
	JOIN menu m ON s.product_id=m.product_id
)

SELECT customer_id, SUM(points) AS total_points FROM cte
GROUP BY customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?  
WITH cte AS(
	SELECT s.customer_id, 
	       m.product_name,
               mb.join_date,
               s.order_date, 
               DATE_ADD(join_date, INTERVAL 6 DAY) AS first_week,
               CASE 
		   WHEN m.product_name = 'sushi' THEN ROUND(m.price*20,1) 
		   WHEN s.order_date BETWEEN mb.join_date AND DATE_ADD(mb.join_date, INTERVAL 6 DAY) THEN ROUND(m.price*20,1) 
                   ELSE ROUND(m.price*10,1) 
	       END AS points 
	FROM sales s
	JOIN menu m ON s.product_id=m.product_id
        JOIN members mb ON s.customer_id=mb.customer_id
)

SELECT customer_id, SUM(points) AS total_points FROM cte
WHERE EXTRACT(MONTH FROM order_date) = 1
GROUP BY customer_id
ORDER BY customer_id;

-- Bonus Questions

-- Join All The Things
SELECT s.customer_id,
       s.order_date,
       m.product_name,
       m.price,
	      CASE
		  WHEN mb.join_date > s.order_date THEN 'N'
		  WHEN mb.join_date <= s.order_date THEN 'Y'
                  ELSE 'N'
	      END AS members
FROM sales s
LEFT JOIN members mb ON mb.customer_id = s.customer_id
LEFT JOIN menu m ON s.product_id=m.product_id;

-- Rank All The Things
WITH cte AS (
SELECT s.customer_id,
       s.order_date,
       m.product_name,
       m.price,
	       CASE
		   WHEN mb.join_date > s.order_date THEN 'N'
		   WHEN mb.join_date <= s.order_date THEN 'Y'
                   ELSE 'N'
	       END AS members
FROM sales s
LEFT JOIN members mb ON mb.customer_id = s.customer_id
LEFT JOIN menu m ON s.product_id=m.product_id)

SELECT *,
	 CASE 
	      WHEN members = 'Y'
	      THEN DENSE_RANK() OVER(PARTITION BY customer_id, members ORDER BY order_date) 
	      ELSE null
         END AS ranking 
FROM cte;
