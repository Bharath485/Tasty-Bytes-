WITH order_detail AS (
    SELECT
        MENU_ITEM_ID,
        QUANTITY,
        PRICE
    FROM {{ source('tb_101', 'ORDER_DETAIL') }}
),

menu AS (
    SELECT
        MENU_ITEM_ID,
        SALE_PRICE_USD,
        ITEM_CATEGORY
    FROM {{ source('tb_101', 'MENU') }}
),

aggregated_sales AS (
    SELECT
        MENU_ITEM_ID,
        SUM(QUANTITY) AS quantity_sold,
        SUM(PRICE) AS total_sales_amount
    FROM order_detail
    GROUP BY MENU_ITEM_ID
),

final AS (
    SELECT
        agg.MENU_ITEM_ID AS menu_item_id,
        COALESCE(agg.quantity_sold, 0) AS quantity_sold,
        COALESCE(agg.total_sales_amount, 0) AS total_sales_amount,
        COALESCE(m.SALE_PRICE_USD, 0) AS unit_sale_price,
        m.ITEM_CATEGORY AS item_category
    FROM aggregated_sales agg
    LEFT JOIN menu m
        ON agg.MENU_ITEM_ID = m.MENU_ITEM_ID
)

SELECT * FROM final
