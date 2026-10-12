SELECT
    ROUND(100.0 * SUM(CASE WHEN NOT is_late THEN 1 ELSE 0 END) / COUNT(*), 1) AS on_time_pct,
    ROUND(AVG(days_late), 2)                                                  AS avg_days_late,
    ROUND(AVG(scheduled_days), 2)                                             AS avg_scheduled_days,
    ROUND(AVG(actual_days), 2)                                                AS avg_actual_days,
    SUM(order_sales)                                                          AS total_sales,
    SUM(order_profit)                                                         AS total_profit,
    ROUND(AVG(CASE WHEN is_late THEN profit_margin END), 4)                   AS avg_margin_late,
    ROUND(AVG(CASE WHEN NOT is_late THEN profit_margin END), 4)               AS avg_margin_on_time
FROM orders;
