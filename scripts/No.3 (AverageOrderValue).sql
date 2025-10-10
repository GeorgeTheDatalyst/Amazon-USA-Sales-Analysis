/*
3. Average Order Value (AOV) Compute the average order value for each customer. 
Challenge: Include only customers with more than 5 orders.
*/
SELECT CONCAT_WS(' ',first_name,last_name) AS customer_name, c.customer_id, COUNT(oi.order_id) AS order_count,ROUND(AVG(oi.quantity*oi.price_per_unit),2) AS avg_revenue
FROM order_items oi
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN customers c ON o.customer_id=c.customer_id
GROUP BY CONCAT_WS(' ',first_name,last_name),c.customer_id
HAVING COUNT(oi.order_id) > 5