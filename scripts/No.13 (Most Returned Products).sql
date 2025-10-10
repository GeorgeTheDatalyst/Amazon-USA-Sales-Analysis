/*
13. Most Returned Products 
Query the top 10 products by the number of returns. 
Challenge: Display the return rate as a percentage of total units sold for each product.
*/

WITH quantity_returned AS (
		SELECT p.product_id,p.product_name, SUM(oi.quantity) AS quantity_returned
		FROM order_items oi 
		LEFT JOIN orders o ON oi.order_id=o.order_id
		LEFT JOIN products p ON oi.product_id=p.product_id
		WHERE o.order_status = 'Returned'
		GROUP BY p.product_id,p.product_name),

total_units_sold AS(
		SELECT p.product_id,SUM(quantity) AS total_quantity_sold
		FROM order_items oi
		LEFT JOIN orders o ON oi.order_id=o.order_id
		LEFT JOIN products p ON oi.product_id=p.product_id
		WHERE o.order_status='Completed'
		GROUP BY p.product_id
		)
SELECT 
qr.product_id,
qr.product_name,
qr.quantity_returned, 
ROUND((CAST(qr.quantity_returned AS FLOAT)*100/NULLIF(us.total_quantity_sold,0)),2) AS return_rate_percentage
FROM quantity_returned qr
LEFT JOIN total_units_sold us ON qr.product_id=us.product_id
ORDER BY qr.quantity_returned DESC
