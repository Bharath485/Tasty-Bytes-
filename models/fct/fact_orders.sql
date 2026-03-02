WITH order_header AS (
    SELECT
        ORDER_ID,
        ORDER_TS
    FROM {{ source('tb_101', 'ORDER_HEADER') }}
),

order_detail AS (
    SELECT
        ORDER_ID,
        PRICE,
        QUANTITY
    FROM {{ source('tb_101', 'ORDER_DETAIL') }}
),

order_detail_agg AS (
    SELECT
        ORDER_ID,
        SUM(PRICE) AS total_line_amount,
        SUM(QUANTITY) AS total_quantity
    FROM order_detail
    GROUP BY ORDER_ID
),

final AS (
    SELECT
        oh.ORDER_ID AS order_id,
        COALESCE(oh.ORDER_TS, CURRENT_TIMESTAMP()) AS order_timestamp,
        COALESCE(oda.total_line_amount, 0) AS total_line_amount,
        COALESCE(oda.total_quantity, 0) AS total_quantity
    FROM order_header oh
    LEFT JOIN order_detail_agg oda
        ON oh.ORDER_ID = oda.ORDER_ID
)

SELECT * FROM final
