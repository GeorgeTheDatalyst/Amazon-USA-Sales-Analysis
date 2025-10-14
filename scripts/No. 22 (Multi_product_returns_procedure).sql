CREATE PROCEDURE multi_product_returns 
    @OrderID INT,
    @ProductReturns ProductReturnType READONLY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ReturnDate DATETIME = GETDATE();

        -- Validate order
        IF NOT EXISTS (SELECT 1 FROM orders WHERE order_id = @OrderID)
        BEGIN
            RAISERROR('Invalid Order ID.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Prevent duplicate return
        IF EXISTS (
            SELECT 1 FROM orders WHERE order_id = @OrderID AND order_status = 'Returned'
        )
        BEGIN
            RAISERROR('Order has already been returned.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Update order status
        UPDATE orders
        SET order_status = 'Returned'
        WHERE order_id = @OrderID;

        -- Update shipping status
        UPDATE shipping
        SET delivery_status = 'Returned',
            return_date = @ReturnDate
        WHERE order_id = @OrderID;

        -- Update payment status
        UPDATE payments
        SET payment_status = 'Refunded'
        WHERE order_id = @OrderID;

        -- Process each product return
        DECLARE @ProductID INT, @Quantity INT;

        DECLARE product_cursor CURSOR FOR
        SELECT ProductID, Quantity FROM @ProductReturns;

        OPEN product_cursor;
        FETCH NEXT FROM product_cursor INTO @ProductID, @Quantity;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Validate quantity
            IF @Quantity <= 0
            BEGIN
                RAISERROR('Invalid quantity for ProductID %d.', 16, 1, @ProductID);
                ROLLBACK TRANSACTION;
                RETURN;
            END

            -- Update inventory
            UPDATE inventory
            SET stock = stock + @Quantity
            WHERE product_id = @ProductID;

            -- Log the return
            INSERT INTO returns_log (order_id, product_id, quantity, return_date)
            VALUES (@OrderID, @ProductID, @Quantity, @ReturnDate);

            FETCH NEXT FROM product_cursor INTO @ProductID, @Quantity;
        END

        CLOSE product_cursor;
        DEALLOCATE product_cursor;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
