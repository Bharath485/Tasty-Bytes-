

with order_detail_source as (
    select
        order_detail_id,
        order_id,
        coalesce(price, 0) as price
    from dbt_poc.RAW.ORDER_DETAIL
    
        where order_detail_id > (select max(order_detail_id) from DBT_POC.DEV.fact_order_line_sales)
    
),

order_header_source as (
    select
        order_id,
        order_ts,
        location_id,
        truck_id
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

joined_data as (
    select
        od.order_detail_id,
        od.order_id,
        dd.date_key,
        dl.location_key,
        dt.truck_key,
        od.price as line_sales_amount_usd
    from order_detail_source od
    left join order_header_source oh on od.order_id = oh.order_id
    left join date_lookup dd on date(oh.order_ts) = dd.date
    left join location_lookup dl on oh.location_id = dl.location_id
    left join truck_lookup dt on oh.truck_id = dt.truck_id
)

select
    cast(order_detail_id as number) as order_detail_id,
    cast(order_id as number) as order_id,
    cast(date_key as number) as date_key,
    cast(location_key as number) as location_key,
    cast(truck_key as number) as truck_key,
    cast(line_sales_amount_usd as number(10,2)) as line_sales_amount_usd
from joined_data