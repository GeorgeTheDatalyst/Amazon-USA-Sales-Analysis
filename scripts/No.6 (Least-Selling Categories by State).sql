/*
6. Least-Selling Categories by State 
Identify the least-selling product category for each state. 
Challenge: Include the total sales for that category within each state.
*/

WITH product_origin AS(
	SELECT c.category_name,s.origin, ROUND(SUM(oi.quantity*oi.price_per_unit),2) AS revenue
	FROM order_items oi
	LEFT JOIN orders o ON oi.order_id=o.order_id
	LEFT JOIN sellers s ON o.seller_id=s.seller_id
	LEFT JOIN products p ON oi.product_id=p.product_id
	LEFT JOIN category c ON p.category_id=c.category_id
	GROUP BY c.category_name,s.origin
	),
category_performance_rank AS (
	SELECT *, ROUND(SUM(revenue) OVER(PARTITION BY origin ORDER BY category_name),2) AS cumulative_revenue, ROW_NUMBER() OVER(PARTITION BY origin ORDER BY revenue ASC) AS category_rank
	FROM product_origin)
SELECT category_name,origin,revenue
FROM category_performance_rank
WHERE category_rank=1



