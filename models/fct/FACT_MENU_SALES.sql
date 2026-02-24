{{ config(materialized='incremental', unique_key='menu_item_id') }}

-- Aggregated menu sales fact table combining order details and menu information
with order_details as (
    select
        menu_item_id,
        quantity,
        price
    from {{ source('tb_101', 'ORDER_DETAIL') }}
    {% if is_incremental() %}
        where updated_at > (select max(updated_at) from {{ this }})
    {% endif %}
),

menu_info as (
    select
        menu_item_id,
        sale_price_usd,
        item_category
    from {{ source('tb_101', 'MENU') }}
),

aggregated_sales as (
    select
        od.menu_item_id,
        sum(od.quantity) as quantity_sold,
        sum(od.price) as total_sales_amount
    from order_details od
    group by od.menu_item_id
)

select
    cast(agg.menu_item_id as varchar) as menu_item_id,
    cast(agg.quantity_sold as integer) as quantity_sold,
    cast(agg.total_sales_amount as decimal(18,2)) as total_sales_amount,
    cast(m.sale_price_usd as decimal(18,2)) as unit_sale_price,
    cast(m.item_category as varchar) as item_category
from aggregated_sales agg
left join menu_info m
    on agg.menu_item_id = m.menu_item_id