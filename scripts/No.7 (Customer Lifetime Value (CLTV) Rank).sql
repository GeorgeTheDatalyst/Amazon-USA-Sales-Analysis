/*
7. Customer Lifetime Value (CLTV) 
Calculate the total value of orders placed by each customer over their lifetime. 
Challenge: Rank customers based on their CLTV.
*/
WITH customer_order_value AS (SELECT c.customer_id,CONCAT_WS(' ',first_name,last_name) AS customer_name,ROUND(SUM(oi.quantity*oi.price_per_unit),2) AS total_order_value_CLV
FROM order_items oi
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id,CONCAT_WS(' ',first_name,last_name))
SELECT*, ROW_NUMBER() OVER(ORDER BY total_order_value_CLV DESC) AS customer_lifetime_value_rank
FROM customer_order_value