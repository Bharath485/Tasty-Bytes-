{{ config(materialized='table') }}

with menu_data as (
    select
        cast(menu_item_id as varchar) as menu_item_key,
        cast(item_category as varchar) as item_category
    from {{ source('tb_101', 'MENU') }}
),

order_aggregations as (
    select
        cast(menu_item_id as varchar) as menu_item_id,
        sum(cast(quantity as integer)) as quantity_sold,
        sum(cast(price as decimal(10,2))) as total_sales_amount
    from {{ source('tb_101', 'ORDER_DETAIL') }}
    group by cast(menu_item_id as varchar)
)

select
    m.menu_item_key,
    m.item_category,
    o.quantity_sold,
    o.total_sales_amount
from menu_data m
left join order_aggregations o
    on m.menu_item_key = o.menu_item_id