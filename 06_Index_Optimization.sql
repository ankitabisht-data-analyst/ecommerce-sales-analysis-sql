
# creating indexes



USE ecommerce_analytics;

CREATE INDEX idx_orders_customer
ON orders(customer_id);

CREATE INDEX idx_orders_date
ON orders(order_date);

CREATE INDEX idx_orderitems_order
ON order_items(order_id);

CREATE INDEX idx_orderitems_product
ON order_items(product_id);

CREATE INDEX idx_returns_order
ON returns(order_id);

CREATE INDEX idx_orderitems_product ON order_items(product_id); 

CREATE INDEX idx_returns_order ON returns(order_id); 

CREATE INDEX idx_products_perf ON products (product_id, selling_price); 

-- 2. Optimises the largest table (order items)
 CREATE INDEX idx_order_items_perf ON order_items (order_id, product_id, quantity); 
 
 -- 3. Optimises mapping orders to customers 
CREATE INDEX idx_orders_perf ON orders (order_id, customer_id);




