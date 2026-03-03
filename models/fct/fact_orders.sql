{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

with order_header as (
    select
        cast(ORDER_ID as INTEGER) as order_id,
        cast(ORDER_TS as TIMESTAMP) as order_timestamp
    from {{ source('tb_101', 'ORDER_HEADER') }}
),

order_detail_aggregated as (
    select
        cast(ORDER_ID as INTEGER) as order_id,
        cast(sum(PRICE) as NUMERIC) as total_line_amount,
        cast(sum(QUANTITY) as INTEGER) as total_quantity
    from {{ source('tb_101', 'ORDER_DETAIL') }}
    group by ORDER_ID
),

final as (
    select
        oh.order_id,
        oh.order_timestamp,
        coalesce(od.total_line_amount, 0) as total_line_amount,
        coalesce(od.total_quantity, 0) as total_quantity
    from order_header oh
    left join order_detail_aggregated od
        on oh.order_id = od.order_id
    {% if is_incremental() %}
    where oh.order_timestamp > (select max(order_timestamp) from {{ this }})
    {% endif %}
)

select * from final
