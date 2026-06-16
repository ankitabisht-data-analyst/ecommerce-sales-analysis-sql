## Basic level (sql)--

-- QUERY 01 : TOTAL CUSTOMERS

SELECT
    COUNT(*) AS total_customers
FROM customers;


-- QUERY 02 : TOTAL ORDERS

SELECT
    COUNT(*) AS total_orders
FROM orders;


-- QUERY 03 : TOTAL PRODUCTS

SELECT
    COUNT(*) AS total_products
FROM products;


 -- QUERY 04 : CUSTOMER SEGMENTS

SELECT
    segment,
    COUNT(*) AS total_customers
FROM customers
GROUP BY segment
ORDER BY total_customers DESC;


-- QUERY 05 : ORDER STATUS ANALYSIS

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- QUERY 06 : TOP SELLING PRODUCTS

SELECT
    product_id,
    SUM(quantity) AS total_quantity_sold
FROM order_items
GROUP BY product_id
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- QUERY 07 : CUSTOMER DISTRIBUTION BY CITY

SELECT
    city,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC;


-- QUERY 08 : AVERAGE PRODUCT PRICE


SELECT
    ROUND(
        AVG(selling_price),
        2
    ) AS average_product_price
FROM products;


-- QUERY 09 : INVENTORY BY WAREHOUSE

SELECT
    warehouse,
    SUM(stock_quantity) AS total_stock
FROM inventory
GROUP BY warehouse
ORDER BY total_stock DESC;


-- QUERY 10 : RETURNS ANALYSIS

SELECT
    COUNT(*) AS total_returns
FROM returns;