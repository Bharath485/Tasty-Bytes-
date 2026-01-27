{{ config(materialized='table') }}

with source_order_detail as (
    select
        order_detail_id,
        order_id,
        price
    from {{ source('tb_101', 'ORDER_DETAIL') }}
),

source_order_header as (
    select
        order_id,
        order_ts,
        location_id,
        truck_id
    from {{ source('tb_101', 'ORDER_HEADER') }}
),

date_lookup as (
    select
        date_key,
        date
    from {{ ref('dim_date') }}
),

location_lookup as (
    select
        location_key,
        location_id
    from {{ ref('dim_location') }}
),

truck_lookup as (
    select
        truck_key,
        truck_id
    from {{ ref('dim_truck') }}
),

joined_data as (
    select
        od.order_detail_id,
        od.order_id,
        oh.order_ts,
        oh.location_id,
        oh.truck_id,
        coalesce(od.price, 0) as price
    from source_order_detail od
    left join source_order_header oh
        on od.order_id = oh.order_id
),

final as (
    select
        cast(jd.order_detail_id as varchar) as order_detail_id,
        cast(jd.order_id as varchar) as order_id,
        cast(dl.date_key as varchar) as date_key,
        cast(ll.location_key as varchar) as location_key,
        cast(tl.truck_key as varchar) as truck_key,
        cast(jd.price as decimal(10,2)) as line_sales_amount_usd
    from joined_data jd
    left join date_lookup dl
        on date(jd.order_ts) = dl.date
    left join location_lookup ll
        on jd.location_id = ll.location_id
    left join truck_lookup tl
        on jd.truck_id = tl.truck_id
)

select
    order_detail_id,
    order_id,
    date_key,
    location_key,
    truck_key,
    line_sales_amount_usd
from final