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
```sql
CREATE TABLE category(
category_id INT IDENTITY(1,1) PRIMARY KEY,
category_name NVARCHAR(50),
)
```
