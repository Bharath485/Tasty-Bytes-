{{ config(materialized='table') }}

with order_header as (
    select
        cast(ORDER_ID as varchar) as order_id,
        cast(ORDER_TS as timestamp) as order_ts
    from {{ source('tb_101', 'ORDER_HEADER') }}
),

order_detail as (
    select
        cast(ORDER_ID as varchar) as order_id,
        cast(PRICE as decimal(10,2)) as price,
        cast(QUANTITY as integer) as quantity
    from {{ source('tb_101', 'ORDER_DETAIL') }}
),

order_aggregations as (
    select
        order_id,
        sum(price) as total_line_amount,
        sum(quantity) as total_quantity
    from order_detail
    group by order_id
),

final as (
    select
        oh.order_id,
        oh.order_ts as order_timestamp,
        oa.total_line_amount,
        oa.total_quantity
    from order_header oh
    left join order_aggregations oa
        on oh.order_id = oa.order_id
)

select * from final