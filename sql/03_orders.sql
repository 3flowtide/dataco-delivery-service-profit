CREATE OR REPLACE TABLE orders AS
WITH order_agg AS (
    SELECT
        order_id,
        ANY_VALUE(order_date)             AS order_date,
        ANY_VALUE(order_status)           AS order_status,
        ANY_VALUE(delivery_status)        AS delivery_status,
        ANY_VALUE(shipping_mode)          AS shipping_mode,
        ANY_VALUE(scheduled_shipping_days) AS scheduled_days,
        ANY_VALUE(actual_shipping_days)    AS actual_days,
        ANY_VALUE(customer_segment)        AS customer_segment,
        ANY_VALUE(order_region)            AS region,
        ANY_VALUE(market)                  AS market,
        SUM(sales)                         AS order_sales,
        SUM(order_item_profit)             AS order_profit,
        SUM(discount_amount)               AS discount_amount
    FROM orders_raw_selected
    GROUP BY order_id
)
SELECT
    order_id,
    order_date,
    DATE_TRUNC('month', order_date) AS order_month,
    order_status,
    delivery_status,
    shipping_mode,
    region,
    market,
    customer_segment,
    scheduled_days,
    actual_days,
    (actual_days > scheduled_days)            AS is_late,
    GREATEST(actual_days - scheduled_days, 0) AS days_late,
    CASE
        WHEN actual_days <= scheduled_days       THEN 'on time'
        WHEN actual_days - scheduled_days = 1    THEN '1 day late'
        WHEN actual_days - scheduled_days = 2    THEN '2 days late'
        ELSE '3+ days late'
    END                                        AS late_bucket,
    order_sales,
    order_profit,
    discount_amount,
    CASE WHEN order_sales = 0 THEN NULL ELSE order_profit / order_sales END AS profit_margin,
    (order_profit < 0)                        AS is_loss_making
FROM order_agg
WHERE order_status NOT IN ('CANCELED', 'SUSPECTED_FRAUD');
