/*
8. Inventory Stock Alerts 
Query stock status aleart for products stock levels i.e below a certain threshold (e.g., less than 10 units=low). 
Challenge: Include last restock date and warehouse information.
*/

SELECT 
	p.product_name, 
	i.stock, i.last_stock_date, 
	i.warehouse_id,
	CASE
	WHEN i.stock >50 THEN 'Suffient'
	WHEN i.stock BETWEEN 10 AND 49 THEN 'Moderate'
	ELSE 'Low'
	END AS stock_alert
FROM products p
LEFT JOIN inventory i ON p.product_id=i.product_id





