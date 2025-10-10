/*
18. Top 10 product with highest decreasing revenue ratio 
compare to last year(2022) and current_year(2023) 
Challenge: Return product_id, product_name, category_name, 
2022 revenue and 2023 revenue decrease ratio at end Round the result 
Note: Decrease ratio = cr-ls/ls* 100 (cs = current_year ls=last_year)
*/

WITH current_year_sales AS (SELECT 
p.product_id, 
p.product_name,
c.category_name,
SUM(oi.quantity*oi.price_per_unit) AS revenue_2023

FROM order_items oi
LEFT JOIN products p ON oi.product_id=p.product_id
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN category c ON p.category_id=c.category_id
WHERE DATEPART(YEAR,o.order_date) = 2023
GROUP BY p.product_id,p.product_name, c.category_name),

last_year_sales AS (
SELECT 
p.product_id,
p.product_name,
c.category_name,
SUM(oi.quantity*oi.price_per_unit) AS revenue_2022
FROM order_items oi
LEFT JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN products p ON oi.product_id=p.product_id
LEFT JOIN category c ON p.category_id=c.category_id
WHERE DATEPART(year,order_date) = 2022
GROUP BY p.product_id,p.product_name, c.category_name
)
SELECT TOP(10)
ly.product_id,
ly.product_name,
ly.category_name,
ROUND(ly.revenue_2022,2) AS revenue_2022,
ROUND(ISNULL(cy.revenue_2023,0),2) AS revenue_2023,
(ROUND(ISNULL(cy.revenue_2023,0),2) - ROUND(ly.revenue_2022,2)) revenue_change,
(ROUND(((ROUND(ISNULL(cy.revenue_2023,0),2) - ROUND(ly.revenue_2022,2)) / ROUND(ly.revenue_2022,2)),2) * 100) AS percentage_revenue_change
FROM last_year_sales ly
LEFT JOIN current_year_sales cy ON ly.product_id=cy.product_id
ORDER BY percentage_revenue_change ASC