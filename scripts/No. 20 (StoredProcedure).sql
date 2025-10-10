/*
GrandMasterLevel ADVANCED: Stored Procedure
Create a stored procedure for adding products in the inventory.
The procedure should update the quantity of products in the inventory or add a new product in the inventory if it doesnt exist.
It should update the products table if the product doesnt exist in the products list
It should add a new category if the product is of a new category
*/

CREATE PROCEDURE RecordProduct
    @ProductName NVARCHAR(50),
    @ProductID INT,
    @Price FLOAT,
    @Cogs FLOAT,
    @Quantity INT,
    @WarehouseID INT,
    @CategoryName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CategoryID INT;
    DECLARE @LastStockDate DATE = GETDATE();

    -- Check if category exists
    SELECT @CategoryID = category_id
    FROM category
    WHERE category_name = @CategoryName;

    -- If category doesn't exist, insert it
    IF @CategoryID IS NULL
    BEGIN
        INSERT INTO category (category_name)
        VALUES (@CategoryName);

        SET @CategoryID = SCOPE_IDENTITY();
    END

    -- Check if product exists
    IF NOT EXISTS (
        SELECT 1 FROM products WHERE product_id = @ProductID
    )
    BEGIN
        INSERT INTO products (product_id, product_name, price, cogs, category_id)
        VALUES (@ProductID, @ProductName, @Price, @Cogs, @CategoryID);
    END
    ELSE
    BEGIN
        -- Optionally update product info if needed
        UPDATE products
        SET product_name = @ProductName,
            price = @Price,
            cogs = @Cogs,
            category_id = @CategoryID
        WHERE product_id = @ProductID;
    END

    -- Check if inventory record exists
    IF EXISTS (
        SELECT 1 FROM inventory WHERE product_id = @ProductID AND warehouse_id = @WarehouseID
    )
    BEGIN
        UPDATE inventory
        SET stock = stock + @Quantity,
            last_stock_date = @LastStockDate
        WHERE product_id = @ProductID AND warehouse_id = @WarehouseID;
    END
    ELSE
    BEGIN
        INSERT INTO inventory (product_id, stock, warehouse_id, last_stock_date)
        VALUES (@ProductID, @Quantity, @WarehouseID, @LastStockDate);
    END
END;

/*
-- > TESTING
*/

EXEC RecordProduct
    @ProductName = 'SteelSeries Aerox 5 Wireless',
    @ProductID = 1001,
    @Price = 25.99,
    @Cogs = 10.00,
    @Quantity = 50,
    @WarehouseID = 1,
    @CategoryName = 'Accessories';
