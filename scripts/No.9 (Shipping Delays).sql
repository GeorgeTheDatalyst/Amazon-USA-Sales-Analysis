/*
9. Shipping Delays 
Identify orders where the shipping date is later than 3 days after the order date. 
Challenge: Include customer, order details, and delivery provider
			Add shipping_alert to categorize the shipping delay by urgency.
*/

SELECT*,
	CASE 
	WHEN shipping_delay_days>3 THEN 'Late'
	WHEN shipping_delay_days = 2 OR shipping_delay_days = 3 THEN 'Urgent'
	ELSE 'In progress'
	END AS shipping_alert
FROM
	(SELECT 
		c.customer_id, 
		CONCAT_WS(' ',first_name,last_name) AS customer_name,
		c.state, o.order_id,
		o.order_date,
		s.shipping_date, 
		s.shipping_providers,
		DATEDIFF(DAY,o.order_date,s.shipping_date) AS shipping_delay_days
	FROM orders o
	LEFT JOIN shipping s ON o.order_id=s.order_id
	LEFT JOIN customers c ON o.customer_id=c.customer_id)t
WHERE shipping_delay_days >= 3