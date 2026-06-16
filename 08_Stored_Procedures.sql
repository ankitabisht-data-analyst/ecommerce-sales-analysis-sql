## Example 1: Top Customers Report

DELIMITER //

CREATE PROCEDURE GetTopCustomers()
BEGIN

SELECT
    c.customer_name,
    SUM(oi.quantity * p.selling_price) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY revenue DESC
LIMIT 10;
END //
DELIMITER ;

-- run 

CALL GetTopCustomers();


## Example 2: Revenue by Category

Create:

DELIMITER //

CREATE PROCEDURE GetRevenueByCategory()
BEGIN

SELECT
    p.category,
    SUM(oi.quantity * p.selling_price) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

END //

DELIMITER ;

-- run 

CALL GetRevenueByCategory();


Example 3: Monthly Revenue

DELIMITER //

CREATE PROCEDURE GetMonthlyRevenue()
BEGIN

SELECT
    DATE_FORMAT(o.order_date,'%Y-%m') AS month,
    SUM(oi.quantity * p.selling_price) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY month
ORDER BY month;

END //

DELIMITER ;

-- run 

CALL GetMonthlyRevenue();