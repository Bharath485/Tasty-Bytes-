
  
    

create or replace transient table tasty_bytes_dbt_db.DEV.fct_truck_daily_sales
    
    
    
    as (

with order_header_data as (
    select
        cast(order_ts as timestamp) as order_ts,
        cast(truck_id as varchar) as truck_id,
        cast(location_id as varchar) as location_id,
        cast(order_id as varchar) as order_id
    from tasty_bytes_dbt_db.RAW.ORDER_HEADER
),

order_detail_data as (
    select
        cast(order_id as varchar) as order_id,
        cast(price as decimal(10,2)) as price,
        cast(order_item_discount_amount as decimal(10,2)) as order_item_discount_amount
    from tasty_bytes_dbt_db.RAW.ORDER_DETAIL
),

date_lookup as (
    select
        date_key,
        date
    from tasty_bytes_dbt_db.DEV.DIM_DATE
),

truck_lookup as (
    select
        truck_key,
        truck_id
    from tasty_bytes_dbt_db.DEV.DIM_TRUCK
),

location_lookup as (
    select
        location_key,
        location_id
    from tasty_bytes_dbt_db.DEV.DIM_LOCATION
),

order_aggregations as (
    select
        oh.order_ts,
        oh.truck_id,
        oh.location_id,
        count(distinct oh.order_id) as order_count,
        sum(coalesce(od.price, 0)) as gross_sales_usd,
        sum(coalesce(od.price, 0) - coalesce(od.order_item_discount_amount, 0)) as net_sales_usd
    from order_header_data oh
    left join order_detail_data od
        on oh.order_id = od.order_id
    group by
        oh.order_ts,
        oh.truck_id,
        oh.location_id
),

final as (
    select
        dl.date_key,
        tl.truck_key,
        ll.location_key,
        oa.order_count,
        oa.gross_sales_usd,
        oa.net_sales_usd
    from order_aggregations oa
    left join date_lookup dl
        on dl.date = date(oa.order_ts)
    left join truck_lookup tl
        on tl.truck_id = oa.truck_id
    left join location_lookup ll
        on ll.location_id = oa.location_id
)

select
    date_key,
    truck_key,
    location_key,
    order_count,
    gross_sales_usd,
    net_sales_usd
from final
    )
;


  