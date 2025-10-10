/*
Top Selling Products 
Query the top 10 products by total sales value. 
Challenge: Include product name, total quantity sold, and total sales value.
*/

-- > Possible Solution 1:
SELECT TOP(10) p.product_name, p.product_id, SUM(oi.quantity) AS quantity_ordered, ROUND(SUM(oi.quantity*oi.price_per_unit),2) AS revenue
FROM order_items oi
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name,p.product_id
ORDER BY SUM(oi.quantity*oi.price_per_unit) DESC

/* -- > Possible solution 2 
(I suppose revenue earned from a sale can only be attributed 
when the ordered item is delivered and never returned because once 
returned a refund will be made thus the revenue earned from 
the sale of the product should not be counted.) */
SELECT TOP(10) p.product_name, p.product_id, SUM(oi.quantity) AS quantity_ordered, ROUND(SUM(oi.quantity*oi.price_per_unit),2) AS revenue
FROM order_items oi
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN shipping s ON o.order_id=s.order_id
WHERE o.order_status='completed' AND return_date IS NULL
GROUP BY p.product_name,p.product_id
ORDER BY SUM(oi.quantity*oi.price_per_unit) DESC