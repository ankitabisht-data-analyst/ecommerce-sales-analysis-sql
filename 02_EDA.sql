USE ecommerce_analytics;

-- EXPLORATORY DATA ANALYSIS (EDA)

-- 1. DATASET OVERVIEW

-- Total Revenue

SELECT
SUM(oi.quantity * p.selling_price) AS total_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id;

-- Total Customers

SELECT
COUNT(*) AS total_customers
FROM customers;

-- Total Products

SELECT
COUNT(*) AS total_products
FROM products;

-- Total Orders

SELECT
COUNT(*) AS total_orders
FROM orders;

-- Total Quantity Sold

SELECT
SUM(quantity) AS total_quantity_sold
FROM order_items;


-- 2. SALES OVERVIEW

-- Total Payments Received

SELECT
SUM(amount) AS total_payments
FROM payments;

-- Average Order Value

SELECT
ROUND(
SUM(amount) /
COUNT(DISTINCT order_id),
2
) AS average_order_value
FROM payments;

-- Monthly Revenue Trend

SELECT
DATE_FORMAT(o.order_date,'%Y-%m') AS month,
ROUND(SUM(oi.quantity * p.selling_price),2) AS revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY month
ORDER BY month;


-- 3. CUSTOMER OVERVIEW


-- Total Customers by Segment

SELECT
segment,
COUNT(*) AS customer_count
FROM customers
GROUP BY segment
ORDER BY customer_count DESC;

-- Customers by City

SELECT
city,
COUNT(*) AS customers
FROM customers
GROUP BY city
ORDER BY customers DESC;


-- 4. PRODUCT OVERVIEW

-- Total Product Categories

SELECT
COUNT(DISTINCT category) AS total_categories
FROM products;

-- Products per Category

SELECT
category,
COUNT(*) AS product_count
FROM products
GROUP BY category
ORDER BY product_count DESC;

-- Top 10 Selling Products

SELECT
p.product_name,
SUM(oi.quantity) AS quantity_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY quantity_sold DESC
LIMIT 10;

-- Revenue by Category

SELECT
p.category,
ROUND(
SUM(oi.quantity * p.selling_price),2) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;


-- 5. ORDER OVERVIEW

-- Orders by Status

SELECT
order_status,
COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Orders by Month

SELECT
DATE_FORMAT(order_date,'%Y-%m') AS month,
COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;


-- 6. PAYMENT OVERVIEW

-- Payment Method Distribution

SELECT
payment_method,
COUNT(*) AS total_transactions
FROM payments
GROUP BY payment_method
ORDER BY total_transactions DESC;

-- 7. RETURNS OVERVIEW

-- Total Returns

SELECT
COUNT(*) AS total_returns
FROM returns;

-- Returns by Reason

SELECT
return_reason,
COUNT(*) AS total_returns
FROM returns
GROUP BY return_reason
ORDER BY total_returns DESC;

-- Return Rate

SELECT
ROUND(
COUNT(DISTINCT r.return_id) * 100.0 /
COUNT(DISTINCT o.order_id),2) AS return_rate_percentage
FROM orders o
LEFT JOIN returns r
ON o.order_id = r.order_id;


-- 8. INVENTORY OVERVIEW

-- Total Inventory Stock

SELECT
SUM(stock_quantity) AS total_stock
FROM inventory;

-- Lowest Stock Products

SELECT
product_id,
stock_quantity
FROM inventory
ORDER BY stock_quantity
LIMIT 10;
