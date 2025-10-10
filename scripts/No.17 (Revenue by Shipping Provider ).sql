/*
17. Revenue by Shipping Provider 
Calculate the total revenue handled by each shipping provider. 
Challenge: Include the total number of orders handled and the average delivery time for each provider.
*/

SELECT
s.shipping_providers,
ROUND(SUM(oi.quantity*oi.price_per_unit),2) AS revenue_generated,
COUNT(DISTINCT o.order_id) AS order_count,
AVG(DATEDIFF(DAY,O.order_date,S.shipping_date)) AS average_delivery_time
FROM order_items oi
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN shipping s ON o.order_id=s.order_id
WHERE s.shipping_providers IS NOT NULL
GROUP BY s.shipping_providers;


