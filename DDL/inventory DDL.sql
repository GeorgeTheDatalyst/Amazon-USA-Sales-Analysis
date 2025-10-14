CREATE TABLE inventory(
inventory_id INT IDENTITY(1,1) PRIMARY KEY,
product_id INT,
stock INT,
warehouse_id INT,
last_stock_date DATE
)