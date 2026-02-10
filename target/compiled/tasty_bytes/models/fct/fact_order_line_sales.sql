

with order_detail_source as (
    select
        cast(ORDER_DETAIL_ID as varchar) as order_detail_id,
        cast(ORDER_ID as varchar) as order_id,
        cast(PRICE as decimal(10,2)) as price
    from dbt_poc.RAW.ORDER_DETAIL
    
),

order_header_source as (
    select
        cast(ORDER_ID as varchar) as order_id,
        cast(ORDER_TS as timestamp) as order_ts,
        cast(LOCATION_ID as varchar) as location_id,
        cast(TRUCK_ID as varchar) as truck_id
    from dbt_poc.RAW.ORDER_HEADER
),

date_lookup as (
    select
        date_key,
        date
    from DBT_POC.DEV.DIM_DATE
),

location_lookup as (
    select
        location_key,
        location_id
    from DBT_POC.DEV.DIM_LOCATION
),

truck_lookup as (
    select
        truck_key,
        truck_id
    from DBT_POC.DEV.DIM_TRUCK
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

select * from final