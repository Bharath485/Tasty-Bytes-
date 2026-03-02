

with order_detail_source as (
    select
        menu_item_id,
        quantity,
        price
    from dbt_poc.RAW.ORDER_DETAIL
    
        where updated_at > (select max(updated_at) from DBT_POC.DEV.FACT_MENU_SALES)
    
),

menu_source as (
    select
        menu_item_id,
        sale_price_usd,
        item_category
    from dbt_poc.RAW.MENU
),

aggregated_order_data as (
    select
        menu_item_id,
        sum(quantity) as quantity_sold,
        sum(price) as total_sales_amount
    from order_detail_source
    group by menu_item_id
),

final as (
    select
        cast(agg.menu_item_id as integer) as menu_item_id,
        cast(agg.quantity_sold as integer) as quantity_sold,
        cast(agg.total_sales_amount as decimal(10,2)) as total_sales_amount,
        cast(m.sale_price_usd as decimal(10,2)) as unit_sale_price,
        cast(m.item_category as varchar(100)) as item_category
    from aggregated_order_data agg
    left join menu_source m
        on agg.menu_item_id = m.menu_item_id
)

select * from final