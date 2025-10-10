/*
11. Top Performing Sellers 
Find the top 5 sellers based on total sales value. 
Challenge: Include both successful and failed orders, and display their percentage of successful orders.
*/

WITH successful_orders AS
(SELECT s.seller_id,s.seller_name, ROUND(SUM(oi.quantity*oi.price_per_unit),2) AS successful_order_value, COUNT(o.order_id) AS compleated_orders
FROM order_items oi
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN sellers s ON o.seller_id=s.seller_id
WHERE o.order_status = 'Completed'
GROUP BY s.seller_id,s.seller_name),

total_orders AS(
SELECT s.seller_id, COUNT(o.order_id) AS total_orders,ROUND(SUM(oi.quantity*oi.price_per_unit),2) AS total_order_value
FROM order_items oi
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN sellers s ON o.seller_id=s.seller_id
GROUP BY s.seller_id
)
SELECT TOP(5) so.seller_id,so.seller_name,t.total_order_value,so.successful_order_value, so.compleated_orders,t.total_orders,ROUND((CAST(so.successful_order_value AS FLOAT)/NULLIF(t.total_order_value,0)),2)*100 AS success_rate_percentage
FROM successful_orders so
LEFT JOIN total_orders t ON so.seller_id=t.seller_id
ORDER BY total_order_value DESC
