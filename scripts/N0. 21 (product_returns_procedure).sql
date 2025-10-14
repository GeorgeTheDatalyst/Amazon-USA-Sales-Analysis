/*
Create a stored procedure to handle returns. 
The stored procedure should update the order status in orders table to returned,
shipping delivery status to returned,
payment status to refunded and 
add the inventory table by the quantity returned as the products have been restocked for future sale.
The stored procedure should avoid returning already returned products and instead return
an error indicating the product has already been returned.
Additionally, the procedure should check if the order_id and product_id input are valid.
*/

CREATE PROCEDURE product_returns 
    @OrderID INT,
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ReturnDate DATE = GETDATE();

        -- validation to ensure the @OrderID and @ProductID exist before proceeding:
        IF NOT EXISTS (SELECT 1 FROM orders WHERE order_id = @OrderID)
        BEGIN
            RAISERROR('Invalid Order ID.', 16, 1);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM inventory WHERE product_id = @ProductID)
        BEGIN
            RAISERROR('Invalid Product ID.', 16, 1);
            RETURN;
        END

        -- Ensure the returned quantity is positive:
        IF @Quantity <= 0
        BEGIN
            RAISERROR('Return quantity must be greater than zero.', 16, 1);
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

        -- Add inventory back
        UPDATE inventory
        SET stock = stock + @Quantity
        WHERE product_id = @ProductID;

        -- Log the return
        INSERT INTO returns_log (order_id, product_id, quantity, return_date)
        VALUES (@OrderID, @ProductID, @Quantity, @ReturnDate);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
