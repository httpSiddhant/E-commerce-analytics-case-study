create database ecommerce_analytics;

USE ecommerce_analytics;

SELECT COUNT(*) AS customers FROM customers;
SELECT COUNT(*) AS orders FROM orders;
SELECT COUNT(*) AS order_items FROM order_items;
SELECT COUNT(*) AS products FROM products;

DESCRIBE customers;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE products;

#CHECKING DUPLICATES
SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

#CREATING CLEAN VIEW
CREATE OR REPLACE VIEW orders_clean AS
SELECT DISTINCT
    order_id,
    customer_id,
    order_date,
    status,
    payment_method,
    COALESCE(discount_code, 'No Discount') AS discount_code,
    shipping_fee
FROM orders;


CREATE OR REPLACE VIEW products_clean AS
SELECT
    product_id,
    product_name,
    UPPER(TRIM(category)) AS category,
    list_price,
    unit_cost
FROM products;


CREATE OR REPLACE VIEW order_items_clean AS
SELECT
    oi.order_id,
    oi.product_id,
    oi.quantity,
    COALESCE(oi.unit_price, p.list_price) AS unit_price,
    oi.discount_amount,
    CASE
        WHEN oi.unit_price IS NULL THEN 'Imputed from List Price'
        ELSE 'Original Price'
    END AS price_status
FROM order_items oi
JOIN products_clean p
    ON oi.product_id = p.product_id;
    
#CHECKING CLEANED DATA
SELECT COUNT(*) AS customers
FROM customers;

SELECT COUNT(*) AS orders_original
FROM orders;

SELECT COUNT(*) AS orders_clean
FROM orders_clean;

SELECT COUNT(*) AS order_items
FROM order_items_clean;

SELECT COUNT(*) AS products
FROM products_clean;

#CHECKING MISSING VALUES
SELECT
    COUNT(*) AS total_items,
    SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS missing_original_price
FROM order_items;

#Analytical View
CREATE OR REPLACE VIEW sales_detail AS
SELECT
    o.order_id,
    o.customer_id,
    c.state,
    c.acquisition_channel,
    o.order_date,
    o.status,
    o.payment_method,
    o.discount_code,
    o.shipping_fee,
    
    oi.product_id,
    p.product_name,
    p.category,
    
    oi.quantity,
    oi.unit_price,
    oi.discount_amount,
    p.unit_cost,

    (oi.quantity * oi.unit_price) AS gross_sales,

    ((oi.quantity * oi.unit_price) - oi.discount_amount) AS net_sales,

    ((oi.quantity * oi.unit_price)
        - oi.discount_amount
        - (oi.quantity * p.unit_cost)) AS profit

FROM orders_clean o

JOIN customers c
    ON o.customer_id = c.customer_id

JOIN order_items_clean oi
    ON o.order_id = oi.order_id

JOIN products_clean p
    ON oi.product_id = p.product_id;
    
#Overall Business KPI
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(net_sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(net_sales), 2) AS average_line_revenue,
    ROUND(SUM(discount_amount), 2) AS total_discount
FROM sales_detail
WHERE status = 'completed';

#AVERAGE ORDER VALUES
SELECT
    ROUND(
        SUM(net_sales) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM sales_detail
WHERE status = 'completed';

#MONTHLY SALES TREND 
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(net_sales), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit
FROM sales_detail
WHERE status = 'completed'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

#CATEGORY PERFROMANCE
SELECT
    category,
    SUM(quantity) AS quantity_sold,
    ROUND(SUM(net_sales), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit
FROM sales_detail
WHERE status = 'completed'
GROUP BY category
ORDER BY revenue DESC;

#TOP 10 PRODUCTS
SELECT
    product_id,
    product_name,
    category,
    SUM(quantity) AS quantity_sold,
    ROUND(SUM(net_sales), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit
FROM sales_detail
WHERE status = 'completed'
GROUP BY
    product_id,
    product_name,
    category
ORDER BY revenue DESC
LIMIT 10;

#CUSTOMER PERFORMANCE 
SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(net_sales), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit
FROM sales_detail
WHERE status = 'completed'
GROUP BY customer_id
ORDER BY revenue DESC
LIMIT 10;

#REVENUE BY STATE
SELECT
    state,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(net_sales), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit
FROM sales_detail
WHERE status = 'completed'
GROUP BY state
ORDER BY revenue DESC;

#ACUISITION CHANNEL PERFORMANCE
SELECT
    acquisition_channel,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(net_sales), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit
FROM sales_detail
WHERE status = 'completed'
GROUP BY acquisition_channel
ORDER BY revenue DESC;

#PAYMENT METHOD ANALYSIS
SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(net_sales), 2) AS revenue
FROM sales_detail
WHERE status = 'completed'
GROUP BY payment_method
ORDER BY revenue DESC;

#CANCELATION ANALYSIS
SELECT
    COUNT(DISTINCT order_id) AS cancelled_orders,
    ROUND(SUM(net_sales), 2) AS cancelled_value
FROM sales_detail
WHERE status = 'canceled';

#RETURNED ORDERS
SELECT
    COUNT(DISTINCT order_id) AS returned_orders,
    ROUND(SUM(net_sales), 2) AS returned_value
FROM sales_detail
WHERE status = 'returned';

#ORDER STATUS SUMMARY
SELECT
    status,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(net_sales), 2) AS value
FROM sales_detail
GROUP BY status
ORDER BY orders DESC;

#DISCOUNT ANALYSIS 
SELECT
    discount_code,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(discount_amount), 2) AS discount_given,
    ROUND(SUM(net_sales), 2) AS revenue
FROM sales_detail
WHERE status = 'completed'
GROUP BY discount_code
ORDER BY revenue DESC;

#PORFIT MARGIN BY CATEGORY
SELECT
    category,
    ROUND(SUM(net_sales), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(net_sales), 0)) * 100,
        2
    ) AS profit_margin
FROM sales_detail
WHERE status = 'completed'
GROUP BY category
ORDER BY profit_margin DESC;


SELECT COUNT(*) AS orphan_orders
FROM orders_clean o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS orphan_order_items
FROM order_items_clean oi
LEFT JOIN orders_clean o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS orphan_products
FROM order_items_clean oi
LEFT JOIN products_clean p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;