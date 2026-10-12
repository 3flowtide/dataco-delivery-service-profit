COPY (SELECT * FROM orders) TO 'data/processed/orders.csv' (HEADER);

COPY (
    SELECT
        order_month,
        COUNT(*)                                                                  AS n_orders,
        ROUND(100.0 * SUM(CASE WHEN NOT is_late THEN 1 ELSE 0 END) / COUNT(*), 1) AS on_time_pct
    FROM orders
    GROUP BY order_month
    ORDER BY order_month
) TO 'data/processed/monthly_summary.csv' (HEADER);

COPY (
    SELECT
        shipping_mode, region, market, customer_segment,
        COUNT(*)                                 AS n_orders,
        SUM(CASE WHEN is_late THEN 1 ELSE 0 END) AS late_orders
    FROM orders
    GROUP BY shipping_mode, region, market, customer_segment
) TO 'data/processed/segment_summary.csv' (HEADER);
