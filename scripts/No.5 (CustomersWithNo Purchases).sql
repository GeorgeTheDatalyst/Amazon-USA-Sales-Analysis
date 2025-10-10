/*
5. Customers with No Purchases 
Find customers who have registered but never placed an order. 
*/

SELECT c.customer_id,CONCAT_WS(' ',first_name,last_name) AS customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id=o.customer_id
WHERE o.order_id IS NULL;