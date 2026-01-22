

with menu_data as (
    select
        cast(menu_item_id as varchar) as menu_item_id,
        cast(item_category as varchar) as item_category
    from tasty_bytes_dbt_db.RAW.MENU
),

order_detail_aggregated as (
    select
        cast(menu_item_id as varchar) as menu_item_id,
        sum(cast(quantity as integer)) as quantity_sold,
        sum(cast(price as decimal(10,2))) as total_sales_amount
    from tasty_bytes_dbt_db.RAW.ORDER_DETAIL
    group by cast(menu_item_id as varchar)
)

select
    m.menu_item_id as menu_item_key,
    coalesce(od.quantity_sold, 0) as quantity_sold,
    coalesce(od.total_sales_amount, 0.00) as total_sales_amount,
    m.item_category
from menu_data m
left join order_detail_aggregated od
    on m.menu_item_id = od.menu_item_id