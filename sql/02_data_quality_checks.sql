SELECT
    COUNT(*)                                            AS row_count,
    COUNT(DISTINCT order_id)                            AS distinct_orders,
    ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT order_id), 2) AS avg_lines_per_order
FROM orders_raw_selected;

SELECT order_status, COUNT(*) AS n
FROM orders_raw_selected
GROUP BY order_status
ORDER BY n DESC;

SELECT delivery_status, COUNT(*) AS n
FROM orders_raw_selected
GROUP BY delivery_status
ORDER BY n DESC;

SELECT shipping_mode, COUNT(*) AS n
FROM orders_raw_selected
GROUP BY shipping_mode
ORDER BY n DESC;

SELECT
    SUM(CASE WHEN scheduled_shipping_days IS NULL THEN 1 ELSE 0 END) AS null_scheduled_days,
    SUM(CASE WHEN actual_shipping_days IS NULL THEN 1 ELSE 0 END)    AS null_actual_days,
    SUM(CASE WHEN scheduled_shipping_days < 0 THEN 1 ELSE 0 END)     AS negative_scheduled_days,
    SUM(CASE WHEN actual_shipping_days < 0 THEN 1 ELSE 0 END)        AS negative_actual_days
FROM orders_raw_selected;

SELECT
    delivery_status,
    (actual_shipping_days > scheduled_shipping_days) AS calculated_is_late,
    COUNT(*) AS n
FROM orders_raw_selected
GROUP BY delivery_status, calculated_is_late
ORDER BY delivery_status, calculated_is_late;

SELECT order_status, delivery_status, COUNT(*) AS n
FROM orders_raw_selected
WHERE delivery_status = 'Shipping canceled'
GROUP BY order_status, delivery_status;

SELECT
    DATE_TRUNC('month', order_date) AS order_month,
    COUNT(DISTINCT order_id)        AS n_orders
FROM orders_raw_selected
GROUP BY order_month
ORDER BY order_month;

SELECT
    SUM(CASE WHEN order_item_profit < 0 THEN 1 ELSE 0 END) AS loss_making_lines,
    COUNT(*)                                                AS total_lines
FROM orders_raw_selected;

SELECT
    SUM(CASE WHEN n_category > 1 THEN 1 ELSE 0 END) AS orders_with_mixed_category,
    COUNT(*)                                         AS total_orders
FROM (
    SELECT order_id, COUNT(DISTINCT product_category) AS n_category
    FROM orders_raw_selected
    GROUP BY order_id
);

SELECT
    SUM(CASE WHEN ABS("Sales" - "Order Item Product Price" * "Order Item Quantity") > 0.01 THEN 1 ELSE 0 END) AS sales_vs_price_times_qty_mismatches,
    SUM(CASE WHEN ABS("Order Item Total" - ("Sales" - "Order Item Discount")) > 0.01 THEN 1 ELSE 0 END)        AS item_total_vs_sales_minus_discount_mismatches,
    SUM(CASE WHEN ABS("Benefit per order" - "Order Profit Per Order") > 0.01 THEN 1 ELSE 0 END)                AS benefit_vs_profit_per_order_mismatches,
    COUNT(*)                                                                                                    AS total_lines
FROM raw_orders;
