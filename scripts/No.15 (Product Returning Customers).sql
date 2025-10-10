/*
15. Product Returning Customers
IDENTITY new customers into product returning or already existing as a returning customer. 
If the customer has done more than 5 return categorize them as returning otherwise new 
Challenge: List customers id, name, total orders, total returns
*/

-- > APPROACH 1 (Filters out only the RETURNING customers)
WITH customer_returns AS
(SELECT c.customer_id,CONCAT_WS(' ',first_name,last_name) AS custoomer_name,COUNT(o.order_id) AS total_returns
FROM order_items oi
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN customers c ON o.customer_id=c.customer_id
WHERE o.order_status = 'Returned'
GROUP BY c.customer_id,CONCAT_WS(' ',first_name,last_name)),

total_orders AS(
SELECT c.customer_id, COUNT(o.order_id) AS total_orders
FROM order_items oi 
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id
)
SELECT cr.customer_id,cr.custoomer_name,cr.total_returns,t.total_orders,
CASE 
WHEN total_returns > 5 THEN 'Returning' 
ELSE 'New'
END AS customer_type
FROM customer_returns cr
LEFT JOIN total_orders t ON  cr.customer_id=t.customer_id
GROUP BY cr.customer_id,cr.custoomer_name,cr.total_returns,t.total_orders
ORDER BY cr.total_returns DESC;

-- > APPROACH 2 (Displays the whole list of both RETURNING and NEW customers)
WITH customer_returns AS
(SELECT c.customer_id,CONCAT_WS(' ',first_name,last_name) AS custoomer_name,COUNT(CASE WHEN order_status='Returned' THEN 1 END) AS total_returns
FROM order_items oi
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id,CONCAT_WS(' ',first_name,last_name)),

total_orders AS(
SELECT c.customer_id, COUNT(o.order_id) AS total_orders
FROM order_items oi 
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id
)
SELECT cr.customer_id,cr.custoomer_name,cr.total_returns,t.total_orders,
CASE 
WHEN total_returns > 5 THEN 'Returning' 
ELSE 'New'
END AS customer_type
FROM customer_returns cr
LEFT JOIN total_orders t ON  cr.customer_id=t.customer_id
GROUP BY cr.customer_id,cr.custoomer_name,cr.total_returns,t.total_orders
ORDER BY cr.total_returns DESC