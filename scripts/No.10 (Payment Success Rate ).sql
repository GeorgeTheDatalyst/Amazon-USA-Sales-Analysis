/*
10. Payment Success Rate 
Calculate the percentage of successful payments across all orders. 
Challenge: Include breakdowns by payment status (e.g., failed, pending).
*/

SELECT payment_status,payment_status_count, ((payment_status_count * 100/(SELECT COUNT(payment_status)
																	FROM payments))) AS percentage_contribution
FROM (SELECT payment_status, COUNT(payment_status) AS payment_status_count
FROM payments
GROUP BY payment_status)t