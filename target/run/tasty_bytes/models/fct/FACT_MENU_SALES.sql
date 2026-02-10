
  
    

create or replace transient table tasty_bytes_dbt_db.DEV.FACT_MENU_SALES
    
    
    
    as (

with order_detail_source as (
    select
        cast(MENU_ITEM_ID as varchar) as menu_item_id,
        cast(QUANTITY as integer) as quantity,
        cast(PRICE as decimal(10,2)) as price
    from tasty_bytes_dbt_db.RAW.ORDER_DETAIL
    
),

menu_source as (
    select
        cast(MENU_ITEM_ID as varchar) as menu_item_id,
        cast(SALE_PRICE_USD as decimal(10,2)) as sale_price_usd,
        cast(ITEM_CATEGORY as varchar) as item_category
    from tasty_bytes_dbt_db.RAW.MENU
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
    )
;


  