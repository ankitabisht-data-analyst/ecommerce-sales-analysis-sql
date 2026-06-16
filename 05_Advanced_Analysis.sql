## ADVANCED LEVEL QUERIES

USE ecommerce_analytics;  


-- Q 01 : CUSTOMER REVENUE RANKING(customers rank based on total revenue generated? )
-- BUSINESS PROBLEM: Management wants to identify the highest-value customers.
 

WITH customer_revenue AS
(
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.selling_price) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name)

SELECT *,
       RANK() OVER(ORDER BY revenue DESC) AS customer_rank
FROM customer_revenue;



-- QUERY 02: Top Product Within Each Category


WITH product_sales AS
(
    SELECT
        p.category,
        p.product_name,
        SUM(oi.quantity) AS total_quantity_sold
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.category,
        p.product_name)
SELECT *
FROM
( SELECT *, ROW_NUMBER()
            OVER( PARTITION BY category
            ORDER BY total_quantity_sold DESC) AS rn
    FROM product_sales) x
WHERE rn = 1;



-- QUERY 03 : RUNNING REVENUE TOTAL

WITH monthly_sales AS
(
    SELECT
        DATE_FORMAT(o.order_date,'%Y-%m') AS sales_month,
        SUM(oi.quantity * p.selling_price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY sales_month
)

SELECT
    sales_month,
    revenue,
    SUM(revenue)
    OVER(ORDER BY sales_month)
    AS running_revenue
FROM monthly_sales;


-- QUERY 04: Month-over-Month Revenue Growth


WITH monthly_sales AS
(
    SELECT
        DATE_FORMAT(order_date,'%Y-%m') AS month_name,
        SUM(oi.quantity * p.selling_price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY month_name
)

SELECT
    month_name,
    revenue,
    LAG(revenue)
    OVER(ORDER BY month_name)
    AS previous_month_revenue
FROM monthly_sales;

-- QUERY 05: Revenue Difference from Previous Month

WITH monthly_sales AS
(
    SELECT
        DATE_FORMAT(order_date,'%Y-%m') AS month_name,
        SUM(oi.quantity * p.selling_price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY month_name
)

SELECT
    month_name,
    revenue,
    revenue -
    LAG(revenue)
    OVER(ORDER BY month_name)
    AS revenue_change
FROM monthly_sales;


-- QUERY 06 : ROLLING 3 MONTH REVENUE

WITH monthly_sales AS
(
    SELECT
        DATE_FORMAT(order_date,'%Y-%m') AS month_name,
        SUM(oi.quantity * p.selling_price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY month_name)

SELECT
    month_name,
    revenue,
    AVG(revenue)
    OVER(
        ORDER BY month_name
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_avg
FROM monthly_sales;

-- QUERY 07 : CUSTOMER LIFETIME VALUE


SELECT
    c.customer_id,
    c.customer_name,
    ROUND(
        SUM(oi.quantity * p.selling_price),2) AS customer_lifetime_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY customer_lifetime_value DESC;


-- QUERY 08 : DENSE RANK CUSTOMERS

WITH customer_revenue AS
(
    SELECT
        customer_id,
        SUM(oi.quantity * p.selling_price) revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY customer_id
)

SELECT *,
       DENSE_RANK()
       OVER(ORDER BY revenue DESC)
       AS dense_rank_customer
FROM customer_revenue;


-- QUERY 09 : PRODUCT RANKING

SELECT
    p.product_name,
    SUM(oi.quantity * p.selling_price) revenue,
    RANK()
    OVER(
        ORDER BY
        SUM(oi.quantity * p.selling_price) DESC
    ) product_rank
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_name;

-- QUERY 10 : TOP CUSTOMERS PER CITY

WITH city_revenue AS
(SELECT
    c.city,
    c.customer_name,
    SUM(oi.quantity*p.selling_price) revenue
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON o.order_id=oi.order_id
JOIN products p
ON oi.product_id=p.product_id
GROUP BY
    c.city,
    c.customer_name)
SELECT *
FROM(
SELECT *,
ROW_NUMBER()
OVER(
PARTITION BY city
ORDER BY revenue DESC) rn
FROM city_revenue
)x
WHERE rn<=5;


-- QUERY 11 : CUMULATIVE ORDERS

SELECT
    order_date,
    COUNT(*) orders_count,
    SUM(COUNT(*))
    OVER(
        ORDER BY order_date
    ) cumulative_orders
FROM orders
GROUP BY order_date;

-- QUERY 12 : CUSTOMER REVENUE QUARTILES


WITH customer_revenue AS
(
SELECT
customer_id,
SUM(oi.quantity*p.selling_price) revenue
FROM orders o
JOIN order_items oi
ON o.order_id=oi.order_id
JOIN products p
ON oi.product_id=p.product_id
GROUP BY customer_id)

SELECT *,
NTILE(4)
OVER(
ORDER BY revenue DESC
)
AS revenue_quartile
FROM customer_revenue;

-- QUERY 13 : PREVIOUS CUSTOMER ORDER


SELECT
customer_id,
order_id,
order_date,
LAG(order_date)
OVER(
PARTITION BY customer_id
ORDER BY order_date
)
AS previous_order_date

FROM orders;

-- QUERY 14 : NEXT CUSTOMER ORDER
SELECT
customer_id,
order_id,
order_date,

LEAD(order_date)
OVER(
PARTITION BY customer_id
ORDER BY order_date
)
AS next_order_date

FROM orders;


-- QUERY 15 : CUSTOMER SEGMENTATION (Which customers belong to Gold, Silver,and Bronze groups?)



WITH customer_revenue AS
(
SELECT
c.customer_id,
c.customer_name,
SUM(oi.quantity*p.selling_price) revenue
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON o.order_id=oi.order_id
JOIN products p
ON oi.product_id=p.product_id
GROUP BY
c.customer_id,
c.customer_name
)

SELECT
customer_id,
customer_name,
revenue,

CASE
WHEN revenue >= 500000 THEN 'Gold'
WHEN revenue >= 250000 THEN 'Silver'
ELSE 'Bronze'
END AS customer_segment

FROM customer_revenue
ORDER BY revenue DESC;