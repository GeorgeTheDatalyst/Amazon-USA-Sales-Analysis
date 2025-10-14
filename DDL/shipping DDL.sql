CREATE TABLE shipping (
    shipping_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    shipping_date DATE,
    return_date DATE,
    shipping_providers NVARCHAR(50),
    delivery_status NVARCHAR(50)
);
