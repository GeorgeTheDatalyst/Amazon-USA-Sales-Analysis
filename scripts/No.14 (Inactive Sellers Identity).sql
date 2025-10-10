/*
14. Inactive Sellers Identity 
sellers who haven’t made any sales in the last 6 months. 
Challenge: Show the last sale date and total sales from those sellers.
*/


SELECT 
	s.seller_id, 
	s.seller_name, 
	MAX(o.order_date) AS last_order_date,
	ROUND(SUM(oi.quantity*oi.price_per_unit),2) AS total_sales, 
	DATEDIFF(MONTH,MAX(o.order_date),GETDATE()) AS inactivity_in_months
FROM order_items oi 
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN sellers s ON o.seller_id=s.seller_id
GROUP BY s.seller_id,s.seller_name
HAVING DATEDIFF(MONTH,MAX(o.order_date),GETDATE()) >= 6
ORDER BY inactivity_in_months DESC