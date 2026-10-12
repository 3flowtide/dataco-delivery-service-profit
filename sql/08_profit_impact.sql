SELECT
    late_bucket,
    COUNT(*)                     AS n_orders,
    ROUND(AVG(order_profit), 2)  AS avg_profit,
    ROUND(AVG(profit_margin), 4) AS avg_margin
FROM orders
GROUP BY late_bucket
ORDER BY late_bucket;

SELECT
    CASE
        WHEN discount_amount = 0 THEN 'no discount'
        WHEN discount_amount / NULLIF(order_sales, 0) <= 0.1 THEN '0-10%'
        WHEN discount_amount / NULLIF(order_sales, 0) <= 0.2 THEN '10-20%'
        ELSE '20%+'
    END                                                                            AS discount_band,
    COUNT(*)                                                                       AS n_orders,
    SUM(CASE WHEN is_loss_making THEN 1 ELSE 0 END)                                AS loss_making_orders,
    ROUND(100.0 * SUM(CASE WHEN is_loss_making THEN 1 ELSE 0 END) / COUNT(*), 1)   AS loss_making_pct
FROM orders
GROUP BY discount_band
ORDER BY discount_band;

SELECT
    is_late,
    COUNT(*)                     AS n_orders,
    SUM(order_profit)            AS total_profit,
    ROUND(AVG(order_profit), 2)  AS avg_profit,
    ROUND(AVG(profit_margin), 4) AS avg_margin
FROM orders
GROUP BY is_late;
