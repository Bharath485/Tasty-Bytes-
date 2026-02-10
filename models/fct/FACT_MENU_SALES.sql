{{ config(materialized='incremental', unique_key='menu_item_id') }}

with order_detail_source as (
    select
        cast(menu_item_id as varchar) as menu_item_id,
        cast(quantity as integer) as quantity,
        cast(price as decimal(10,2)) as price
    from {{ source('tb_101', 'ORDER_DETAIL') }}
    {% if is_incremental() %}
        where updated_at > (select max(updated_at) from {{ this }})
    {% endif %}
),

menu_source as (
    select
        cast(menu_item_id as varchar) as menu_item_id,
        cast(sale_price_usd as decimal(10,2)) as sale_price_usd,
        cast(item_category as varchar) as item_category
    from {{ source('tb_101', 'MENU') }}
),

aggregated_sales as (
    select
        menu_item_id,
        sum(quantity) as quantity_sold,
        sum(price) as total_sales_amount
    from order_detail_source
    group by menu_item_id
),

final as (
    select
        a.menu_item_id,
        a.quantity_sold,
        a.total_sales_amount,
        m.sale_price_usd as unit_sale_price,
        m.item_category
    from aggregated_sales a
    left join menu_source m
        on a.menu_item_id = m.menu_item_id
)

select 
    menu_item_id,
    quantity_sold,
    total_sales_amount,
    unit_sale_price,
    item_category
from final