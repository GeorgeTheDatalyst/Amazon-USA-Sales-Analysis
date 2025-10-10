/*
Advanced Task: Stored Procedure 
Create a stored procedure that, when a product is sold, performs the following actions: 
Inserts a new sales record into the orders and order_items tables. 
Updates the inventory table to reduce the stock based on the product and quantity purchased. The procedure should ensure that the stock is adjusted immediately after recording the sale.
*/
DELLIMITER //

CREATE PROCEDURE RecordSale
    @CustomerID INT,
    @SellerID INT,
    @ProductID INT,
    @Quantity INT,
    @PricePerUnit DECIMAL(10,2),
    @PaymentStatus VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrderID INT;
    DECLARE @OrderStatus VARCHAR(20);

    -- Determine order status
    SET @OrderStatus = CASE 
        WHEN @PaymentStatus = 'Payment Failed' THEN 'Cancelled'
        WHEN @PaymentStatus = 'Payment Successed' THEN 'Completed'
        ELSE 'Inprogress'
    END;

    -- Insert into orders
    INSERT INTO orders (order_date, customer_id, seller_id, order_status)
    VALUES (GETDATE(), @CustomerID, @SellerID, @OrderStatus);

    -- Get the newly created OrderID
    SET @OrderID = SCOPE_IDENTITY();

    -- Insert into order_items
    INSERT INTO order_items (order_id, product_id, quantity, price_per_unit)
    VALUES (@OrderID, @ProductID, @Quantity, @PricePerUnit);

    -- Update inventory
    UPDATE inventory
    SET stock = stock - @Quantity
    WHERE product_id = @ProductID;
END;


/*
=================
PROCEDURE TESTING
=================
*/
EXEC RecordSale 
    @CustomerID = 101,
    @SellerID = 5,
    @ProductID = 2001,
    @Quantity = 2,
    @PricePerUnit = 499.99,
    @PaymentStatus = 'Payment Successed';
