

with order_detail_source as (
    select
        cast(order_detail_id as varchar) as order_detail_id,
        cast(order_id as varchar) as order_id,
        cast(price as decimal(10,2)) as price
    from tasty_bytes_dbt_db.RAW.ORDER_DETAIL
    
        where order_detail_id > (select max(order_detail_id) from tasty_bytes_dbt_db.DEV.fact_order_line_sales)
    
),

order_header_source as (
    select
        cast(order_id as varchar) as order_id,
        cast(order_ts as timestamp) as order_ts,
        cast(location_id as varchar) as location_id,
        cast(truck_id as varchar) as truck_id
    from tasty_bytes_dbt_db.RAW.ORDER_HEADER
),

date_lookup as (
    select
        date_key,
        date
    from tasty_bytes_dbt_db.DEV.DIM_DATE
),

location_lookup as (
    select
        location_key,
        location_id
    from tasty_bytes_dbt_db.DEV.DIM_LOCATION
),

truck_lookup as (
    select
        truck_key,
        truck_id
    from tasty_bytes_dbt_db.DEV.DIM_TRUCK
),

final as (
    select
        od.order_detail_id,
        od.order_id,
        dl.date_key,
        ll.location_key,
        tl.truck_key,
        coalesce(od.price, 0) as line_sales_amount_usd
    from order_detail_source od
    left join order_header_source oh on od.order_id = oh.order_id
    left join date_lookup dl on date(oh.order_ts) = dl.date
    left join location_lookup ll on oh.location_id = ll.location_id
    left join truck_lookup tl on oh.truck_id = tl.truck_id
)

select
    order_detail_id,
    order_id,
    date_key,
    location_key,
    truck_key,
    line_sales_amount_usd
from final



with order_header_source as (
    select
        cast(order_ts as timestamp) as order_ts,
        cast(truck_id as varchar) as truck_id,
        cast(location_id as varchar) as location_id,
        cast(order_id as varchar) as order_id
    from tasty_bytes_dbt_db.RAW.ORDER_HEADER
    
        where order_ts > (select max(order_ts) from tasty_bytes_dbt_db.DEV.fact_order_line_sales)
    
),

order_detail_source as (
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
    from order_header_source oh
    left join order_detail_source od
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
        on date(oa.order_ts) = dl.date
    left join truck_lookup tl
        on oa.truck_id = tl.truck_id
    left join location_lookup ll
        on oa.location_id = ll.location_id
)

select
    date_key,
    truck_key,
    location_key,
    order_count,
    gross_sales_usd,
    net_sales_usd
from final