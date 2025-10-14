# 🛒 Amazon Product Sales Analysis

Welcome to the **Amazon Product Sales Analysis** project — a deep dive into transactional data from a simulated Amazon-like marketplace. This project leverages SQL to uncover insights across sales, inventory, customer behavior, and operational efficiency.

---

## 📊 Project Overview

This repository contains a suite of SQL queries and stored procedures designed to answer key business questions and challenges faced by e-commerce platforms. The goal is to transform raw data into actionable insights for sales optimization, inventory management, and customer engagement.

---

## 🧠 Key Analytical Questions & Challenges

### 1. 🔝 Top Selling Products
- Identify the top 10 products by **total sales value**.
- Challenge: Include **product name**, **total quantity sold**, and **total sales value**.

### 2. 💰 Revenue by Category
- Calculate **total revenue** per product category.
- Challenge: Show **percentage contribution** of each category to overall revenue.

### 3. 📦 Average Order Value (AOV)
- Compute AOV for each customer.
- Challenge: Include **only customers with more than 5 orders**.

### 4. 📈 Monthly Sales Trend
- Analyze monthly sales over the **past year**.
- Challenge: Return **current month**, **last month**, and **monthly trend**.

### 5. 🧍‍♂️ Customers with No Purchases
- Identify customers who registered but **never placed an order**.

### 6. 🧾 Least-Selling Categories by State
- Find the **least-selling category** in each state.
- Challenge: Include **total sales** for that category per state.

### 7. 💎 Customer Lifetime Value (CLTV)
- Calculate **total order value** per customer.
- Challenge: **Rank customers** by CLTV.

### 8. 🚨 Inventory Stock Alerts
- Flag products with **stock below threshold** (e.g., < 10 units).
- Challenge: Include **last restock date** and **warehouse info**.

### 9. 🚚 Shipping Delays
- Identify orders with **shipping delays > 3 days**.
- Challenge: Include **customer**, **order details**, **delivery provider**, and **urgency level**.

### 10. 💳 Payment Success Rate
- Calculate **success rate** of payments.
- Challenge: Breakdown by **status** (e.g., failed, pending, successful).

### 11. 🏆 Top Performing Sellers
- Find top 5 sellers by **total sales value**.
- Challenge: Include **success rate** across all orders.

### 12. 📉 Product Profit Margin
- Calculate **profit margin** (price - COGS) per product.
- Challenge: **Rank products** from highest to lowest margin.

### 13. 🔁 Most Returned Products
- Identify top 10 products by **number of returns**.
- Challenge: Show **return rate** as a percentage of total units sold.

### 14. 💤 Inactive Sellers
- Find sellers with **no sales in the last 6 months**.
- Challenge: Show **last sale date** and **total sales**.

### 15. 🔄 Product Returning Customers
- Categorize customers as **new** or **returning** based on return history.
- Challenge: List **customer ID**, **name**, **total orders**, **total returns**.

### 16. 🗺️ Top 5 Customers by State
- Identify top 5 customers by **order count** in each state.
- Challenge: Include **total orders** and **sales value**.

### 17. 🚛 Revenue by Shipping Provider
- Calculate **total revenue** handled by each provider.
- Challenge: Include **order count** and **average delivery time**.

### 18. 📉 Products with Declining Revenue
- Find top 10 products with highest **revenue drop** from 2022 to 2023.
- Challenge: Include **product ID**, **name**, **category**, **2022 vs 2023 revenue**, and **decrease ratio**.

---

## 🧪 Advanced SQL Tasks

### 🔄 Stored Procedure: Record Sale
- Inserts a new sale into `orders` and `order_items`.
- Updates `inventory` to reduce stock immediately after sale.

### 🧠 GrandMaster Stored Procedure: Inventory Management
- Adds or updates products in `inventory`.
- Inserts new products if they don’t exist.
- Adds new categories if needed.
- Updates `products` table with missing entries.

---
# 📦 `product_returns` Stored Procedure

## Overview
The `product_returns` stored procedure handles the return process for a specific product in a customer order. It ensures that returned items are properly recorded, inventory is updated, and associated order, shipping, and payment statuses are adjusted accordingly.

---

## 🔧 Functionality

When executed, the procedure performs the following operations:

1. **Validates Inputs**:
   - Checks if the provided `@OrderID` exists in the `orders` table.
   - Checks if the provided `@ProductID` exists in the `inventory` table.
   - Ensures the `@Quantity` is greater than zero.

2. **Prevents Duplicate Returns**:
   - If the order has already been marked as `'Returned'`, the procedure raises an error and halts execution.

3. **Updates Related Tables**:
   - **`orders`**: Sets `order_status` to `'Returned'`.
   - **`shipping`**: Sets `delivery_status` to `'Returned'` and logs the return date.
   - **`payments`**: Sets `payment_status` to `'Refunded'`.
   - **`inventory`**: Increases stock by the returned quantity.
   - **`returns_log`**: Inserts a record of the return for auditing and tracking.

4. **Error Handling**:
   - Uses `TRY...CATCH` to manage exceptions.
   - Rolls back the transaction if any error occurs.
   - Raises a descriptive error message to the caller.

---

## 📝 Parameters

| Name         | Type | Description                                  |
|--------------|------|----------------------------------------------|
| `@OrderID`   | INT  | ID of the order being returned               |
| `@ProductID` | INT  | ID of the product being returned             |
|

**`returns_log`**: Inserts a record of the return for auditing and tracking.

4. **Error Handling**:
   - Uses `TRY...CATCH` to manage exceptions.
   - Rolls back the transaction if any error occurs.
   - Raises a descriptive error message to the caller.

---

## 📝 Parameters

| Name         | Type | Description                                  |
|--------------|------|----------------------------------------------|
| `@OrderID`   | INT  | ID of the order being returned               |
| `@ProductID` | INT  | ID of the product being returned             |
| `@Quantity`  | INT  | Quantity of the product being returned       |

---

## 🛑 Error Conditions

- **Invalid Order ID**: If `@OrderID` does not exist.
- **Invalid Product ID**: If `@ProductID` does not exist.
- **Non-positive Quantity**: If `@Quantity` is less than or equal to zero.
- **Duplicate Return**: If the order has already been marked as `'Returned'`.

---

## ✅ Success Outcome

If all validations pass and no errors occur:
- The order is marked as returned.
- The product quantity is restocked.
- Payment is refunded.
- The return is logged for future reference.

---

## 📌 Notes

- This procedure assumes one product per return. For multi-product returns, consider using a table-valued parameter.
- The return date is captured using `GETDATE()` and stored as a `DATE`.
---

## 🗃️ Database Schema

### `products`
```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name NVARCHAR(50),
    price FLOAT,
    cogs FLOAT,
    category_id INT NOT NULL
);
```
### `category`
```sql
CREATE TABLE category(
category_id INT IDENTITY(1,1) PRIMARY KEY,
category_name NVARCHAR(50),
)
```
### `inventory`
```sql
CREATE TABLE inventory(
inventory_id INT IDENTITY(1,1) PRIMARY KEY,
product_id INT,
stock INT,
warehouse_id INT,
last_stock_date DATE
```
### `order_items`
```sql
CREATE TABLE order_items(
order_item_id INT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
price_per_unit FLOAT
```
### `customers`
```sql
CREATE TABLE customers(
customer_id INT PRIMARY KEY,
first_name NVARCHAR(50),
last_name NVARCHAR(50),
state NVARCHAR(50),
)
```
### `orders`
```sql
CREATE TABLE orders(
order_id INT PRIMARY KEY,
order_date DATE,
customer_id INT,
seller_id INT,
order_status NVARCHAR(50)
)
```
### `payments`
```sql
CREATE TABLE payments(
payment_id INT PRIMARY KEY,
order_id INT,
payment_date NVARCHAR(50),
payment_status NVARCHAR(50)
)
```
### `shipping`
```sql
CREATE TABLE shipping (
    shipping_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    shipping_date DATE,
    return_date DATE,
    shipping_providers NVARCHAR(50),
    delivery_status NVARCHAR(50)
);
```
### `sellers`
```sql
CREATE TABLE sellers(
seller_id INT PRIMARY KEY,
seller_name NVARCHAR(50),
origin NVARCHAR(50)
)
```
