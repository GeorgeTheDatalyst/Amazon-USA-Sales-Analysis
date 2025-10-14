CREATE TABLE payments(
payment_id INT PRIMARY KEY,
order_id INT,
payment_date NVARCHAR(50),
payment_status NVARCHAR(50)
)