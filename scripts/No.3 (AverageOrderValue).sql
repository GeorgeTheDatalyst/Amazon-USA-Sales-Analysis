/*
3. Average Order Value (AOV) Compute the average order value for each customer. 
Challenge: Include only customers with more than 5 orders and show the ratio of revenue contribution per customer to the grand total revenue 
generated
*/
SELECT 
    c.customer_id,
    CONCAT_WS(' ', c.first_name, c.last_name) AS customer_name,
    COUNT(o.order_id) AS order_count,
    SUM(oi.quantity * oi.price_per_unit) AS order_value,
    SUM(oi.quantity * oi.price_per_unit) / COUNT(o.order_id) AS avg_order_value_per_customer,
    SUM(oi.quantity * oi.price_per_unit) / 
        (SELECT SUM(suboi.quantity * suboi.price_per_unit) FROM order_items suboi) AS revenue_share
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, CONCAT_WS(' ', c.first_name, c.last_name)
HAVING COUNT(o.order_id) > 5
ORDER BY revenue_share DESC;
