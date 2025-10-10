/*
12. Product Profit Margin 
Calculate the profit margin for each product (difference between price and cost of goods sold). 
Challenge: Rank products by their profit margin, showing highest to lowest.
*/
SELECT product_id,product_name,price,cogs, (price-cogs) AS profit_margin, DENSE_RANK() OVER(ORDER BY profit_margin DESC) AS profit_margin_rank
FROM
(SELECT product_id,product_name,price,cogs, (price-cogs) AS profit_margin
FROM products)t