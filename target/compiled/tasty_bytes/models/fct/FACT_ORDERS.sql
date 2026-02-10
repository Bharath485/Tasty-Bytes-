

with order_header as (
    select
        cast(ORDER_ID as varchar) as order_id,
        cast(ORDER_TS as timestamp) as order_timestamp
    from dbt_poc.RAW.ORDER_HEADER
    
),

order_detail_aggregated as (
    select
        cast(ORDER_ID as varchar) as order_id,
        sum(cast(PRICE as decimal(18,2))) as total_line_amount,
        sum(cast(QUANTITY as integer)) as total_quantity
    from dbt_poc.RAW.ORDER_DETAIL
    
    group by ORDER_ID
),

final as (
    select
        oh.order_id,
        oh.order_timestamp,
        oda.total_line_amount,
        oda.total_quantity
    from order_header oh
    left join order_detail_aggregated oda
        on oh.order_id = oda.order_id
)

select * from final