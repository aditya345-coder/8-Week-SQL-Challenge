# [Case Study #1: Danny's Diner](https://8weeksqlchallenge.com/case-study-1/)
 
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/1.png" alt="Image" width="450" height="450">


View the case study [here.](https://8weeksqlchallenge.com/case-study-1/)

## Introduction
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

## Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:

- sales
- menu
- members
You can inspect the entity relationship diagram and example data below.

 ## Entity Relationship Diagram
 
 <p align="center">
<img src="https://user-images.githubusercontent.com/92220550/230783623-a8b0f477-1830-47e7-94fc-0db2d4dbcf3f.PNG" alt="Image" width="450" height="350">
 
 
## Case Study Questions
Each of the following case study questions can be answered using a single SQL statement:

1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

Click [here](https://github.com/aditya345-coder/8-Week-SQL-Challenge_/blob/main/Case%20Study%20%231%20-%20Danny's%20Diner/Case_Study_1_Danny_s_Diner.sql) to view the solution solution of the case study!

##  Solutions

### **Q1. What is the total amount each customer spent at the restaurant?**
```
SELECT s.customer_id, 
       SUM(m.price) AS total_amount 
FROM sales s
JOIN menu m ON s.product_id=m.product_id
GROUP BY s.customer_id;
```

### **Q2. How many days has each customer visited the restaurant?**
```
SELECT customer_id,
       COUNT(DISTINCT order_date) AS no_times_visited
FROM sales 
GROUP BY customer_id;
```
DISTINCT is used here, because if a customer visited the restaurant multiple times on the same day and placed multiple orders, 
each of those orders would be counted separately as a visit, leading to an inflated count.
  
  
### **Q3. What was the first item from the menu purchased by each customer?**
```
SELECT customer_id, 
       product_name  
FROM (SELECT s.customer_id, 
             m.product_name, 
	     ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rnk
FROM sales s
JOIN menu m ON m.product_id = s.product_id) AS t
WHERE t.rnk=1;
```

### **Q4. What is the most purchased item on the menu and how many times was it purchased by all customers?**
```
SELECT m.product_name,
       COUNT(*) AS most_purchased
FROM sales s
JOIN menu m ON s.product_id=m.product_id
GROUP BY m.product_name
ORDER BY most_purchased DESC
LIMIT 1;
```

### **Q5. Which item was the most popular for each customer?**
```
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
```

### **Q6. Which item was purchased first by the customer after they became a member?**
```
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
```

### **Q7. Which item was purchased just before the customer became a member?**
```
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
```

### **Q8. What is the total items and amount spent for each member before they became a member?**
```
SELECT s.customer_id,
       COUNT(m.product_name) AS number_of_item, 
       SUM(m.price) AS total_amount
FROM sales s
JOIN members mb ON mb.customer_id = s.customer_id
JOIN menu m ON s.product_id=m.product_id
WHERE s.order_date < mb.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;
```

### **Q9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**
```
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
```

### **Q10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**  
```
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
```
## **Bonus Questions**

### **Join All The Things**
```
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
```
						  
### **Rank All The Things**
```						  
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
```
<p>&copy; 2023 Aditya Gaharwar</p>
