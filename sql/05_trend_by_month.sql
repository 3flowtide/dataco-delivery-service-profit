WITH monthly AS (
    SELECT
        order_month,
        COUNT(*)                                                                  AS n_orders,
        ROUND(100.0 * SUM(CASE WHEN NOT is_late THEN 1 ELSE 0 END) / COUNT(*), 1) AS on_time_pct
    FROM orders
    GROUP BY order_month
)
SELECT
    order_month,
    n_orders,
    on_time_pct,
    on_time_pct - LAG(on_time_pct) OVER (ORDER BY order_month) AS on_time_pct_change,
    n_orders - LAG(n_orders) OVER (ORDER BY order_month)       AS order_volume_change
FROM monthly
ORDER BY order_month;
