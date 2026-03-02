

with order_header as (
    select
        order_ts,
        truck_id,
        location_id,
        order_id
    from dbt_poc.RAW.ORDER_HEADER
    
        where order_ts > (select max(order_ts) from DBT_POC.DEV.fct_truck_daily_sales)
    
),

order_detail as (
    select
        order_id,
        price,
        order_item_discount_amount
    from dbt_poc.RAW.ORDER_DETAIL
),

dim_date_lookup as (
    select
        date_key,
        date
    from DBT_POC.DEV.DIM_DATE
),

dim_truck_lookup as (
    select
        truck_key,
        truck_id
    from DBT_POC.DEV.DIM_TRUCK
),

dim_location_lookup as (
    select
        location_key,
        location_id
    from DBT_POC.DEV.DIM_LOCATION
),

order_data as (
    select
        oh.order_ts,
        oh.truck_id,
        oh.location_id,
        oh.order_id,
        od.price,
        od.order_item_discount_amount
    from order_header oh
    inner join order_detail od
        on oh.order_id = od.order_id
),

aggregated_data as (
    select
        date(order_ts) as order_date,
        truck_id,
        location_id,
        count(distinct order_id) as order_count,
        sum(coalesce(price, 0)) as gross_sales_usd,
        sum(coalesce(price, 0) - coalesce(order_item_discount_amount, 0)) as net_sales_usd
    from order_data
    group by
        date(order_ts),
        truck_id,
        location_id
)

select
    dd.date_key,
    dt.truck_key,
    dl.location_key,
    cast(ad.order_count as integer) as order_count,
    cast(ad.gross_sales_usd as decimal(18,2)) as gross_sales_usd,
    cast(ad.net_sales_usd as decimal(18,2)) as net_sales_usd
from aggregated_data ad
left join dim_date_lookup dd
    on dd.date = ad.order_date
left join dim_truck_lookup dt
    on dt.truck_id = ad.truck_id
left join dim_location_lookup dl
    on dl.location_id = ad.location_id
where dd.date_key is not null
    and dt.truck_key is not null
    and dl.location_key is not null