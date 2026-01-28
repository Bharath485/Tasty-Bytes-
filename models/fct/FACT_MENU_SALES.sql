{{ config(materialized='view') }}

with menu_data as (
    select
        cast(menu_item_id as integer) as menu_item_id,
        cast(item_category as varchar) as item_category
    from {{ source('tb_101', 'MENU') }}
),

order_detail_aggregated as (
    select
        cast(menu_item_id as integer) as menu_item_id,
        sum(cast(quantity as integer)) as quantity_sold,
        sum(cast(price as decimal(10,2))) as total_sales_amount
    from {{ source('tb_101', 'ORDER_DETAIL') }}
    group by menu_item_id
)

select
    m.menu_item_id as menu_item_key,
    od.quantity_sold,
    od.total_sales_amount,
    m.item_category
from menu_data m
left join order_detail_aggregated od
    on m.menu_item_id = od.menu_item_id