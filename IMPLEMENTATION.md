# 🛒 Amazon E-Commerce Database Schema



This repository contains the Entity-Relationship Diagram (ERD) and SQL schema for an Amazon-style e-commerce system. It models core business entities such as products, orders, customers, inventory, payments, and shipping — designed for robust analytics and transactional integrity.

---

## 📐 Entity-Relationship Overview

The schema includes the following entities and relationships:

### 1. **order_items**
- `order_item_id` (PK)
- `product_id` (FK → products)
- `order_id` (FK → orders)
- `quantity`
- `price_per_unit`

### 2. **products**
- `product_id` (PK)
- `product_name`
- `price`
- `cogs`
- `category_id` (FK → category)

### 3. **category**
- `category_id` (PK)
- `category_name`

### 4. **customer**
- `customer_id` (PK)
- `first_name`
- `last_name`
- `state`

### 5. **orders**
- `order_id` (PK)
- `customer_id` (FK → customer)
- `order_date`
- `seller_id` (FK → sellers)
- `shipmode_id` (FK → shipping)
- `order_status`

### 6. **sellers**
- `seller_id` (PK)
- `seller_name`
- `origin`

### 7. **shipping**
- `shipmode_id` (PK)
- `shipping_mode`
- `inventory_id` (FK → inventory)
- `return_date`
- `shipping_providers`
- `delivery_status`

### 8. **inventory**
- `inventory_id` (PK)
- `product_id` (FK → products)
- `stock`
- `warehouse_id`
- `stock_date`

### 9. **payments**
- `payment_id` (PK)
- `order_id` (FK → orders)
- `payment_date`
- `payment_status`

---

## 🧠 Schema Highlights

- **Relational Integrity**: All foreign keys are clearly defined to maintain consistency across orders, products, and inventory.
- **Modular Design**: Each entity is normalized to reduce redundancy and improve scalability.
- **Analytics-Ready**: The schema supports advanced queries for sales trends, customer behavior, inventory alerts, and shipping performance.

---

## 📊 Use Cases

This schema is ideal for:
- Building dashboards for product performance and seller metrics
- Running SQL-based analytics on customer lifetime value and return rates
- Designing stored procedures for inventory and order management
- Integrating with BI tools for visual insights

---

## 📜 License

This project is licensed under the MIT License.

---

