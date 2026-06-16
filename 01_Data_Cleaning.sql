# Check NULL Values


USE ecommerce_analytics;


#Customers
SELECT *
FROM customers
WHERE customer_name IS NULL
   OR city IS NULL
   OR segment IS NULL;
   
#Products
SELECT *
FROM products
WHERE category IS NULL;

#Orders
SELECT *
FROM orders
WHERE customer_id IS NULL;

#Order Items
SELECT *
FROM order_items
WHERE quantity IS NULL;
#Check Duplicates
#Customers
SELECT customer_id,
       COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
# Orders
SELECT order_id,
       COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

#Check Invalid Quantities
SELECT *
FROM order_items
WHERE quantity <= 0;
#Check Orphan Records

#Order items without orders:

SELECT oi.*
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


#Phase 4: Exploratory Data Analysis (EDA)

#Total Revenue
SELECT
SUM(oi.quantity * p.selling_price) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id;

#Total Customers
SELECT COUNT(*) AS customers
FROM customers;

#Total Products
SELECT COUNT(*) AS products
FROM products;

#Total Orders
SELECT COUNT(*) AS orders
FROM orders;


-- Duplicate Checks
SELECT customer_id,
COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- Negative Values

SELECT *
FROM order_items
WHERE quantity < 0;


-- Missing Product IDs


SELECT *
FROM order_items
WHERE product_id IS NULL;

