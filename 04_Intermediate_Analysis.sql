 -- INTERMEDIATE QUERIES##-------
 
USE ecommerce_analytics; 

--  QUERY 01 : REVENUE BY CUSTOMER SEGMENT
-- BUSINESS PROBLEM: Management wants to know which customer segment contributes the most revenue.

SELECT
    c.segment,
    ROUND(SUM(oi.quantity * p.selling_price), 2) AS segment_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.segment
ORDER BY segment_revenue DESC;

/*******************************************************************
QUERY 02 : REVENUE BY PRODUCT CATEGORY
********************************************************************/

SELECT
    p.category,
    ROUND(SUM(oi.quantity * p.selling_price),2) AS category_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;

/*******************************************************************
QUERY 03 : TOP CUSTOMERS BY NUMBER OF ORDERS
********************************************************************/

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_orders DESC
LIMIT 10;

/*******************************************************************
QUERY 04 : TOP PRODUCTS BY REVENUE
********************************************************************/

SELECT
    p.product_name,
    ROUND(SUM(oi.quantity * p.selling_price),2) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;

/*******************************************************************
QUERY 05 : MONTHLY REVENUE TREND
********************************************************************/

SELECT
    YEAR(o.order_date) AS year,
    MONTH(o.order_date) AS month,
    ROUND(SUM(oi.quantity * p.selling_price),2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY
    year,
    month;

/*******************************************************************
QUERY 06 : MONTHLY ORDER TREND
********************************************************************/

SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    year,
    month;

/*******************************************************************
QUERY 07 : MOST RETURNED PRODUCTS
********************************************************************/

SELECT
    p.product_name,
    COUNT(*) AS return_count
FROM returns r
JOIN orders o
    ON r.order_id = o.order_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY return_count DESC
LIMIT 10;

/*******************************************************************
QUERY 08 : RETURN RATE BY CATEGORY
********************************************************************/
select
    p.category,
    COUNT(DISTINCT r.order_id) AS returned_orders
FROM returns r
JOIN order_items oi
    ON r.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY returned_orders DESC;  

#OR(2ND WAY)
SELECT
    p.category,
    COUNT(DISTINCT r.order_id) AS returned_orders,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT r.order_id) * 100.0 /
        COUNT(DISTINCT oi.order_id),
        2
    ) AS return_rate_percentage
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN returns r
    ON oi.order_id = r.order_id
GROUP BY p.category
ORDER BY return_rate_percentage DESC;


/*******************************************************************
QUERY 09 : PRODUCTS NEVER SOLD
********************************************************************/

SELECT
    p.product_id,
    p.product_name
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

/*******************************************************************
QUERY 10 : INVENTORY VALUE BY WAREHOUSE
********************************************************************/

SELECT
    i.warehouse,
    ROUND(
        SUM(i.stock_quantity * p.cost_price),
        2
    ) AS inventory_value
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
GROUP BY i.warehouse
ORDER BY inventory_value DESC;

    
/*******************************************************************
QUERY 11: CUSTOMER PURCHASE FREQUENCY
********************************************************************/

SELECT
    customer_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 5
ORDER BY total_orders DESC;

/*******************************************************************
QUERY 12: REVENUE BY CITY
********************************************************************/

SELECT 
    c.city, 
    ROUND(SUM(oi.quantity * p.selling_price), 2) AS revenue 
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
JOIN order_items oi ON o.order_id = oi.order_id 
JOIN products p ON oi.product_id = p.product_id 
GROUP BY c.city 
ORDER BY revenue DESC;

/*******************************************************************
QUERY 13: PROFIT BY CATEGORY
********************************************************************/

SELECT
    p.category,
    ROUND(
        SUM(
            oi.quantity *
            (p.selling_price - p.cost_price)
        ),
        2
    ) AS profit
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY profit DESC;

/*******************************************************************
QUERY 14: REPEAT CUSTOMER ANALYSIS
********************************************************************/

SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1
ORDER BY total_orders DESC;


