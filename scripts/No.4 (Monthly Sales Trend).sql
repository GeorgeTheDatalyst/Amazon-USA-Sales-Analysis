/*
4. Monthly Sales Trend :Query monthly total sales over the past year. 
Challenge: Display the sales trend, grouping by month, return current_month sale, last month sale!
*/

SELECT 
	FORMAT(order_date,'yyyy-MM') AS year_month,
	SUM(oi.quantity*oi.price_per_unit) AS revenue, 
	LAG(SUM(oi.quantity*oi.price_per_unit)) OVER(ORDER BY FORMAT(order_date, 'yyyy-MM')) AS preveious_month_revenue,
	ROUND(SUM(oi.quantity*oi.price_per_unit)-(LAG(SUM(oi.quantity*oi.price_per_unit)) OVER(ORDER BY FORMAT(order_date,'yyyy-MM'))),2) AS revenue_change
FROM order_items oi
LEFT JOIN orders o ON oi.order_id=o.order_id
GROUP BY FORMAT(order_date,'yyyy-MM');

/*
APPROACH 2: Using CTE
*/
WITH current_revenue AS (
		SELECT 
			FORMAT(order_date,'yyyy-MM') AS year_month,
			SUM(oi.quantity*oi.price_per_unit) AS revenue, 
			LAG(SUM(oi.quantity*oi.price_per_unit)) OVER(ORDER BY FORMAT(order_date, 'yyyy-MM')) AS preveious_revenue
		FROM order_items oi
		LEFT JOIN orders o ON oi.order_id=o.order_id
		GROUP BY FORMAT(order_date,'yyyy-MM')
	)
	SELECT 
		year_month,revenue,preveious_revenue,
		ROUND((revenue-preveious_revenue),2) AS revenue_change
	FROM current_revenue
	ORDER BY year_month