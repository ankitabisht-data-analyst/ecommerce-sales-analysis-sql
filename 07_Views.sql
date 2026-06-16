USE ecommerce_analytics;

## View 1: Sales Summary

CREATE VIEW vw_sales_summary AS
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    p.product_name,
    oi.quantity,
    p.selling_price,
    (oi.quantity * p.selling_price) AS revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id;
    
    
--- View 2: Customer Revenue

CREATE VIEW vw_customer_revenue AS
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
    c.customer_name;
    
-- View 3: Product Performance


CREATE VIEW vw_product_performance AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS quantity_sold,
    SUM(oi.quantity * p.selling_price) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category;
    
    
    
    
    select* from vw_sales_summary;
    select* from vw_customer_revenue;
    select* from vw_product_performance ;
    