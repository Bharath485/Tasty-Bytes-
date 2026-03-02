WITH order_header AS (
    SELECT
        ORDER_ID,
        ORDER_TS,
        LOCATION_ID,
        TRUCK_ID,
        CUSTOMER_ID,
        ORDER_TAX_AMOUNT,
        ORDER_CHANNEL,
        ORDER_CURRENCY
    FROM {{ source('tb_101', 'ORDER_HEADER') }}
),

order_detail AS (
    SELECT
        ORDER_DETAIL_ID,
        ORDER_ID,
        QUANTITY,
        UNIT_PRICE,
        PRICE,
        ORDER_ITEM_DISCOUNT_AMOUNT,
        DISCOUNT_ID
    FROM {{ source('tb_101', 'ORDER_DETAIL') }}
),

dim_location AS (
    SELECT
        LOCATION_ID,
        LOCATION_KEY
    FROM {{ ref('dim_location') }}
),

dim_truck AS (
    SELECT
        TRUCK_ID,
        TRUCK_KEY
    FROM {{ ref('dim_truck') }}
),

dim_customer AS (
    SELECT
        CUSTOMER_ID,
        CUSTOMER_KEY
    FROM {{ ref('dim_customers') }}
),

joined AS (
    SELECT
        od.ORDER_DETAIL_ID,
        od.ORDER_ID,
        oh.ORDER_TS,
        oh.LOCATION_ID,
        oh.TRUCK_ID,
        oh.CUSTOMER_ID,
        od.QUANTITY,
        od.UNIT_PRICE,
        od.PRICE,
        od.ORDER_ITEM_DISCOUNT_AMOUNT,
        oh.ORDER_TAX_AMOUNT,
        oh.ORDER_CHANNEL,
        oh.ORDER_CURRENCY,
        od.DISCOUNT_ID,
        dl.LOCATION_KEY,
        dt.TRUCK_KEY,
        dc.CUSTOMER_KEY
    FROM order_detail od
    INNER JOIN order_header oh
        ON od.ORDER_ID = oh.ORDER_ID
    LEFT JOIN dim_location dl
        ON oh.LOCATION_ID = dl.LOCATION_ID
    LEFT JOIN dim_truck dt
        ON oh.TRUCK_ID = dt.TRUCK_ID
    LEFT JOIN dim_customer dc
        ON oh.CUSTOMER_ID = dc.CUSTOMER_ID
),

final AS (
    SELECT
        ORDER_DETAIL_ID AS order_item_id,
        ORDER_ID AS order_id,
        COALESCE(ORDER_TS, CURRENT_TIMESTAMP()) AS order_ts,
        CAST(TO_CHAR(ORDER_TS, 'YYYYMMDD') AS NUMBER(10)) AS order_date_key,
        LOCATION_KEY AS location_key,
        TRUCK_KEY AS truck_key,
        CUSTOMER_KEY AS customer_key,
        CASE WHEN CAST(QUANTITY AS NUMBER(12,2)) < 0 THEN 0 ELSE CAST(QUANTITY AS NUMBER(12,2)) END AS quantity,
        COALESCE(CAST(UNIT_PRICE AS NUMBER(12,2)), 0) AS unit_price,
        COALESCE(CAST(PRICE AS NUMBER(12,2)), 0) AS line_gross_amount,
        COALESCE(CAST(ORDER_ITEM_DISCOUNT_AMOUNT AS NUMBER(12,2)), 0) AS line_discount_amount,
        COALESCE(CAST(PRICE AS NUMBER(12,2)), 0) - COALESCE(CAST(ORDER_ITEM_DISCOUNT_AMOUNT AS NUMBER(12,2)), 0) AS line_net_amount,
        COALESCE(CAST(ORDER_TAX_AMOUNT AS NUMBER(12,2)), 0) AS header_tax_amount,
        COALESCE(TRIM(ORDER_CHANNEL), 'unknown') AS order_channel,
        COALESCE(UPPER(ORDER_CURRENCY), 'USD') AS order_currency,
        DISCOUNT_ID AS discount_id,
        CURRENT_TIMESTAMP() AS dw_insert_ts,
        CURRENT_TIMESTAMP() AS dw_update_ts
    FROM joined
)

SELECT * FROM final
