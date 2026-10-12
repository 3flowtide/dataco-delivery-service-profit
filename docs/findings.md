# DataCo Delivery Performance: Findings

## Headline
Only 42.7% of orders arrive within their scheduled delivery window, and over half of that shortfall traces back to unrealistic shipping-mode schedules rather than genuinely slow delivery. Lateness itself has only a small effect on profit.

## Findings

1. **On-time delivery is low (42.7% of 62,897 in-scope orders), and shipping mode explains almost all of the variation.** "First Class" shipping, scheduled for 1 day, is late on 100% of orders, in every single region with no exception. "Second Class" (2-day schedule) is late 80% of the time; "Standard Class" (4-day schedule), the highest-volume mode at 37,632 orders, is late only 39.8% of the time. By contrast, on-time rates barely move across region (52.6%-60.0% late), market (56.5%-57.7% late) or customer segment (57.2%-57.7% late). The schedule promise, not where or who the order is for, is driving the on-time number.

2. **This looks like a data/schedule artifact, not an operational finding.** A shipping mode that is late 100% of the time in every region, regardless of destination, is consistent with the scheduled transit time being set unrealistically short in this dataset rather than reflecting real carrier performance, not "First Class shipping is broken."

3. **Lateness has a small, consistent, but not dramatic effect on profit.** Average profit per order declines steadily as lateness increases: $62.06 on-time, $60.54 at 1 day late, $58.15 at 2 days late, $56.80 at 3+ days late. Margin follows the same small downward slope (11.11% to 10.95% to 10.38% to 10.14%). This is a real but modest effect (roughly 4-8% relative decline from on-time to 3+ days late), not a profit cliff. Separately, the share of loss-making orders is essentially flat across discount bands (21.1%-21.4% for any discount level vs. 16.8% with no discount), so discounting is not a meaningful driver of unprofitable orders in this dataset.

## Recommendations

1. **Re-baseline the scheduled transit time for "First Class" and "Second Class" shipping before using on-time % as a KPI.** As currently defined, a majority of the on-time shortfall is mechanical (built into the schedule), not something an operations team can fix by shipping faster. Measure: re-run `sql/07_root_cause.sql` after any schedule change and check that late % by shipping mode becomes more uniform and more plausible (not pinned at or near 100%).
2. **If prioritizing delivery-improvement effort, target "Standard Class" volume, not a specific region or segment.** It is the single largest contributor of late orders by count (41.6% of all late orders) simply because of its volume, while region/segment/market show little differentiation worth targeting individually. Measure: track the count and share of late orders coming from Standard Class month over month.
3. **Don't expect a large profit recovery from improving on-time delivery alone. Investigate the ~21% loss-making-order rate directly instead.** The profit gap between on-time and late orders is modest (about $2-5 per order), while roughly 1 in 5 orders are loss-making regardless of discount level. That is a larger, more direct profit lever than delivery timing. Measure: loss-making order % and average order profit, tracked independently of delivery performance.
