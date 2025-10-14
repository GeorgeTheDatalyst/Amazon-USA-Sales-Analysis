CREATE TABLE products(
product_id INT PRIMARY KEY,
product_name NVARCHAR(50),
price FLOAT,
cogs FLOAT,
category_id INT NOT NULL
)