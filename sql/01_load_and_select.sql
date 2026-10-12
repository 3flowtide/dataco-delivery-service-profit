-- cp1252 encoding fix
CREATE OR REPLACE TABLE raw_orders AS
SELECT *
FROM read_csv(
    'data/raw/DataCoSupplyChainDataset.csv',
    header = true,
    encoding = 'cp1252',
    sample_size = -1
);

-- drop identifying fields
CREATE OR REPLACE TABLE orders_raw_selected AS
SELECT
    "Order Id"                                               AS order_id,
    "Order Item Id"                                          AS order_item_id,
    strptime("order date (DateOrders)", '%-m/%-d/%Y %H:%M')  AS order_date,
    "Order Status"                                           AS order_status,
    "Delivery Status"                                        AS delivery_status,
    "Shipping Mode"                                          AS shipping_mode,
    "Days for shipping (real)"                               AS actual_shipping_days,
    "Days for shipment (scheduled)"                          AS scheduled_shipping_days,
    "Customer Segment"                                       AS customer_segment,
    "Order Region"                                           AS order_region,
    "Order Country"                                          AS order_country,
    "Market"                                                 AS market,
    "Category Name"                                          AS product_category,
    "Product Name"                                           AS product_name,
    "Sales"                                                  AS sales,
    "Order Item Discount"                                    AS discount_amount,
    "Order Item Discount Rate"                               AS discount_rate,
    "Order Item Profit Ratio"                                AS profit_ratio,
    "Order Profit Per Order"                                 AS order_item_profit,
    "Order Item Quantity"                                    AS quantity
FROM raw_orders;
