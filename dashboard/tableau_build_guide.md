# Tableau Build Guide

Mechanical build steps for the dashboard. Connect to the three files in
`data/processed/` as three separate data sources (no need to relate/blend them;
each sheet below says which file it uses).

Numbers to check each sheet against (from `scripts/run_pipeline.py` output):
on-time 42.7%, margin on-time 11.11% vs late 10.68%, late % by shipping mode
First Class 100% / Second Class 80% / Standard Class 39.8% / Same Day 48.4%,
avg profit by late_bucket: on time $62.06 / 1 day $60.54 / 2 days $58.15 / 3+ $56.80.

## Connect
- `orders.csv`: set `order_date` and `order_month` to Date, `is_late` /
  `is_loss_making` to Boolean if not auto-detected.
- `monthly_summary.csv`
- `segment_summary.csv`

## Calculated fields (on the orders.csv source)
- `On Time Pct` = `SUM(IIF([Is Late], 0, 1)) / COUNT([Order Id])`
- `Late Bucket Sort` = `CASE [Late Bucket] WHEN 'on time' THEN 1 WHEN '1 day late' THEN 2 WHEN '2 days late' THEN 3 ELSE 4 END`
- `On Time Label` = `IIF([Is Late], 'Late', 'On Time')`: use this field for
  color everywhere so the legend and colors stay in sync across sheets.

## Sheet 1: KPI tiles (3 small sheets, orders.csv)
- "On-Time %": `On Time Pct` on Text, big font, no other shelves.
- "Margin, On Time": `AVG(IF NOT [Is Late] THEN [Profit Margin] END)` on Text.
- "Margin, Late": `AVG(IF [Is Late] THEN [Profit Margin] END)` on Text.

## Sheet 2: Monthly on-time trend (monthly_summary.csv)
- Columns: `order_month` (continuous, by month).
- Rows: `on_time_pct`.
- Mark type: Line.

## Sheet 3: On-time % by shipping mode (orders.csv)
- Rows: `shipping_mode`.
- Columns: `On Time Pct`.
- Mark type: Bar. Sort descending by the measure.
- Color: `On Time Label` won't apply here (this is one bar per mode, not
  split by on-time/late); leave bars a single color or color by mode.

## Sheet 4: On-time % by region (orders.csv)
- Same as Sheet 3 but Rows = `region`. 23 regions, expect a long list, that's
  expected (this is the sheet that shows region barely matters vs. shipping mode).

## Sheet 5: Profit by late bucket (orders.csv)
- Rows: `late_bucket`, sorted by `Late Bucket Sort` ascending (right-click the
  field on Rows > Sort > By Field > `Late Bucket Sort` > Ascending).
- Columns: `AVG(order_profit)`.
- Mark type: Bar. Color: `On Time Label`.

## Sheet 6: Worst segments by late-order volume (segment_summary.csv)
- Add calculated field `Late Pct` = `[late_orders] / [n_orders]`.
- Text table, Rows: `shipping_mode`, `region`, `market`, `customer_segment`.
- Measures: `n_orders`, `late_orders`, `Late Pct`.
- Sort descending by `late_orders` (volume, not rate).
- Filter: Top 10 by `late_orders` (right-click the measure's filter > Top > By field > Top 10 by Sum of late_orders), and exclude rows where `n_orders` < 100.

## Dashboard
- New dashboard, fixed size (e.g. 1200x800, "Generic Desktop" in the size dropdown).
- Title text box at top: "Only 42.7% of Orders Ship On Time, Mostly a
  Shipping-Schedule Artifact, Not Slow Delivery".
- Layout: KPI tiles (Sheet 1) across the top; trend (Sheet 2) and the two
  ranked-bar sheets (3, 4) in the middle row; profit-by-bucket (Sheet 5) and
  worst-segments table (Sheet 6) on the bottom row.
- Colors: two only, on-time vs. late, driven by `On Time Label` everywhere
  it appears, so the legend stays consistent across sheets.
- Filters: add `order_month` and `market` as dashboard filters (Dashboard menu
  > Filters, or drag the fields onto the dashboard and set "Apply to Worksheets
  > All Using This Data Source").

## Publish
1. Check the KPI tiles and bar charts against the numbers listed at the top of
   this file.
2. Server > Tableau Public > Save to Tableau Public As... (sign in, name it,
   publish).
3. Copy the published link into `README.md` (`**Dashboard:** [link]`).
4. Dashboard > Export Image, save as `dashboard/screenshots/dashboard.png`.
