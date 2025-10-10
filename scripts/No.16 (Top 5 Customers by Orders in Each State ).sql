/*
16. Top 5 Customers by Orders in Each State 
Identify the top 5 customers with the highest number of orders for each state. 
Challenge: Include the number of orders and total sales for each customer.
*/
WITH customer_orders AS (SELECT c.customer_id,c.state, CONCAT_WS(' ', c.first_name,c.last_name) AS customer_name,
COUNT(DISTINCT o.order_id) AS order_count,
SUM(oi.quantity*oi.price_per_unit) AS total_sales
FROM order_items oi
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN customers c ON o.customer_id=c.customer_id
WHERE o.order_status='completed'
GROUP BY c.customer_id,c.first_name,c.last_name, c.state),

ranked_customers AS(
SELECT*,
	ROW_NUMBER() OVER(PARTITION BY state ORDER BY order_count DESC) order_rank
FROM customer_orders
)
SELECT customer_id,customer_name,state,order_count,ROUND(total_sales,2) AS total_sales
FROM ranked_customers 
WHERE order_rank <= 5
ORDER by state, order_count DESC;


