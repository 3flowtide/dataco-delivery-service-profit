WITH order_level AS (
    SELECT 'shipping_mode' AS segment_type, shipping_mode AS segment_value,
           COUNT(*) AS n_orders, SUM(CASE WHEN is_late THEN 1 ELSE 0 END) AS late_orders
    FROM orders GROUP BY shipping_mode
    UNION ALL
    SELECT 'region', region,
           COUNT(*), SUM(CASE WHEN is_late THEN 1 ELSE 0 END)
    FROM orders GROUP BY region
    UNION ALL
    SELECT 'market', market,
           COUNT(*), SUM(CASE WHEN is_late THEN 1 ELSE 0 END)
    FROM orders GROUP BY market
    UNION ALL
    SELECT 'customer_segment', customer_segment,
           COUNT(*), SUM(CASE WHEN is_late THEN 1 ELSE 0 END)
    FROM orders GROUP BY customer_segment
),
category_level AS (
    SELECT
        'product_category' AS segment_type,
        l.product_category AS segment_value,
        COUNT(DISTINCT o.order_id) AS n_orders,
        COUNT(DISTINCT CASE WHEN o.is_late THEN o.order_id END) AS late_orders
    FROM orders o
    JOIN orders_raw_selected l ON l.order_id = o.order_id
    GROUP BY l.product_category
),
by_segment AS (
    SELECT * FROM order_level
    UNION ALL
    SELECT * FROM category_level
)
SELECT
    segment_type,
    segment_value,
    n_orders,
    late_orders,
    ROUND(100.0 * late_orders / n_orders, 1)                                           AS late_pct,
    ROUND(100.0 * late_orders / SUM(late_orders) OVER (PARTITION BY segment_type), 1)   AS share_of_late_orders
FROM by_segment
WHERE n_orders >= 100
ORDER BY segment_type, late_pct DESC;
