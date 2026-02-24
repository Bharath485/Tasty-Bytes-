{{ config(materialized='incremental', unique_key='order_id') }}

with order_header as (
    select
        order_id,
        order_ts
    from {{ source('tb_101', 'ORDER_HEADER') }}
    {% if is_incremental() %}
        where order_ts > (select max(order_timestamp) from {{ this }})
    {% endif %}
),

order_detail_aggregated as (
    select
        order_id,
        sum(price) as total_line_amount,
        sum(quantity) as total_quantity
    from {{ source('tb_101', 'ORDER_DETAIL') }}
    {% if is_incremental() %}
        where order_id in (
            select order_id 
            from {{ source('tb_101', 'ORDER_HEADER') }}
            where order_ts > (select max(order_timestamp) from {{ this }})
        )
    {% endif %}
    group by order_id
),

final as (
    select
        cast(oh.order_id as varchar) as order_id,
        cast(oh.order_ts as timestamp) as order_timestamp,
        cast(oda.total_line_amount as decimal(18,2)) as total_line_amount,
        cast(oda.total_quantity as integer) as total_quantity
    from order_header oh
    left join order_detail_aggregated oda
        on oh.order_id = oda.order_id
)

select 
    order_id,
    order_timestamp,
    total_line_amount,
    total_quantity
from final