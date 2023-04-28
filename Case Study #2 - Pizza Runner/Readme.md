# Case Study #2 - Pizza Runner

<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/2.png" alt="Image" width="450" height="450">
  
 View the case study [here.](https://8weeksqlchallenge.com/case-study-2/) 

## Introduction
Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

## Available Data
Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth.

He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

All datasets exist within the pizza_runner database schema - be sure to include this reference within your SQL scripts as you start exploring the data and answering the case study questions.

## Entity Relationship Diagram

<p align="center">
<img src="https://user-images.githubusercontent.com/92220550/234104650-53ff5a5e-1689-4be8-b044-5e69f7c5ecb9.PNG" alt="Image" width="450" height="350">

<details>
  <summary><h2>Case Study Questions</h2></summary>
This case study has LOTS of questions - they are broken up by area of focus including:

- Pizza Metrics
- Runner and Customer Experience
- Ingredient Optimisation
- Pricing and Ratings
- Bonus DML Challenges (DML = Data Manipulation Language)
Each of the following case study questions can be answered using a single SQL statement.

Again, there are many questions in this case study - please feel free to pick and choose which ones you’d like to try!

Before you start writing your SQL queries however - you might want to investigate the data, you may want to do something with some of those null values and data types in the customer_orders and runner_orders tables!

 <details>
    <summary><h3>A. Pizza Metrics</h3></summary>  
    <ol>
      <li>How many pizzas were ordered?</li>
      <li>How many unique customer orders were made?</li>
      <li>How many successful orders were delivered by each runner?</li>
      <li>How many of each type of pizza was delivered?</li>
      <li>How many Vegetarian and Meatlovers were ordered by each customer?</li>
      <li>What was the maximum number of pizzas delivered in a single order?</li>
      <li>For each customer, how many delivered pizzas had at least 1 change and how many had no changes?</li>
      <li>How many pizzas were delivered that had both exclusions and extras?</li>
      <li>What was the total volume of pizzas ordered for each hour of the day?</li>
      <li>What was the volume of orders for each day of the week?</li>
    </ol>
  </details>  

  <details>
  <summary><h3>B. Runner and Customer Experience</h3></summary>
    <ol>
      <li>How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)</li>
      <li>What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?</li>
      <li>Is there any relationship between the number of pizzas and how long the order takes to prepare?</li>
      <li>What was the average distance travelled for each customer?</li>
      <li>What was the difference between the longest and shortest delivery times for all orders?</li>
      <li>What was the average speed for each runner for each delivery and do you notice any trend for these values?</li>
      <li>What is the successful delivery percentage for each runner?</li>
    </ol>
  </details>    

  
   <details>
        <summary><h3>C. Ingredient Optimisation<h3></summary>
        <ol>
          <li>What are the standard ingredients for each pizza?</li>
          <li>What was the most commonly added extra?</li>
          <li>What was the most common exclusion?</li>
          <li>Generate an order item for each record in the customers_orders table in the format of one of the following:
             <ul>
               <li>Meat Lovers</li>
               <li>Meat Lovers - Exclude Beef</li>
               <li>Meat Lovers - Extra Bacon</li>
               <li>Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers</li>
            </ul>
          </li>
          <li>Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
              <ul><li>For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"</li></ul></li>
<li>What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?</li>
        </ol> 
      </details>   

          <details>
            <summary><h3>D. Pricing and Ratings</h3></summary>
            <ol>
              <li>If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?</li>
              <li<What if there was an additional $1 charge for any pizza extras?
          <ul><i>Add cheese is $1 extra</li></ul></li>
            <li>The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.</li>
          <li>Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
            <ul>
              <li>customer_id</li>
              <li>order_id</li>
              <li>runner_id</li>
              <li>rating</li>
              <li>order_time</li>
              <li>pickup_time</li>
              <li>Time between order and pickup</li>
              <li>Delivery duration</li>
              <li>Average speed</li>
              <li>Total number of pizzas</li>
            </ul>
          </li>
<li>If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?</li>
          </details>

          <details>
            <summary><h3>E. Bonus Questions</h3></summary>
If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?  
     </details>
</details>
