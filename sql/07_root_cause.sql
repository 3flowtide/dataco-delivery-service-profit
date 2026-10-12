SELECT
    shipping_mode,
    scheduled_days,
    COUNT(*)                                                                  AS n_orders,
    SUM(CASE WHEN is_late THEN 1 ELSE 0 END)                                  AS late_orders,
    ROUND(100.0 * SUM(CASE WHEN is_late THEN 1 ELSE 0 END) / COUNT(*), 1)     AS late_pct
FROM orders
GROUP BY shipping_mode, scheduled_days
ORDER BY shipping_mode, scheduled_days;

SELECT
    region,
    shipping_mode,
    COUNT(*)                                                              AS n_orders,
    ROUND(100.0 * SUM(CASE WHEN is_late THEN 1 ELSE 0 END) / COUNT(*), 1) AS late_pct
FROM orders
GROUP BY region, shipping_mode
ORDER BY region, late_pct DESC;
