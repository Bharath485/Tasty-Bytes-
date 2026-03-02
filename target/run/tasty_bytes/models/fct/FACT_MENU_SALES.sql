
  
    

create or replace transient table DBT_POC.DEV.FACT_MENU_SALES
    
    
    
    as (

-- Aggregated menu sales fact table combining order details and menu information
with order_details as (
    select
        menu_item_id,
        quantity,
        price
    from dbt_poc.RAW.ORDER_DETAIL
    
),

menu_info as (
    select
        menu_item_id,
        sale_price_usd,
        item_category
    from dbt_poc.RAW.MENU
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
    )
;


  