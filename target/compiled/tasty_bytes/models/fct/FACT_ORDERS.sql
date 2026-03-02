

with order_header as (
    select
        order_id,
        order_ts
    from dbt_poc.RAW.ORDER_HEADER
    
        where order_ts > (select max(order_timestamp) from DBT_POC.DEV.FACT_ORDERS)
    
),

order_detail_aggregated as (
    select
        order_id,
        sum(price) as total_line_amount,
        sum(quantity) as total_quantity
    from dbt_poc.RAW.ORDER_DETAIL
    
        where order_id in (
            select order_id 
            from dbt_poc.RAW.ORDER_HEADER
            where order_ts > (select max(order_timestamp) from DBT_POC.DEV.FACT_ORDERS)
        )
    
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