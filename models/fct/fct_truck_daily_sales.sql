{{ config(materialized='incremental', unique_key='date_key || truck_key || location_key') }}

with order_data as (
    select
        -- Date dimension lookup
        cast(date(ORDER_TS) as string) as date_key,
        
        -- Truck dimension lookup  
        TRUCK_ID as truck_key,
        
        -- Location dimension lookup
        LOCATION_ID as location_key,
        
        -- Order metrics
        ORDER_ID,
        ORDER_TS
        
    from {{ source('tb_101', 'ORDER_HEADER') }}
    {% if is_incremental() %}
        where ORDER_TS > (select max(ORDER_TS) from {{ this }})
    {% endif %}
),

order_detail_data as (
    select
        oh.ORDER_ID,
        
        -- Sales metrics
        sum(coalesce(od.PRICE, 0)) as gross_sales_usd,
        sum(coalesce(od.PRICE, 0) - coalesce(od.ORDER_ITEM_DISCOUNT_AMOUNT, 0)) as net_sales_usd
        
    from {{ source('tb_101', 'ORDER_HEADER') }} oh
    inner join {{ source('tb_101', 'ORDER_DETAIL') }} od
        on oh.ORDER_ID = od.ORDER_ID
    {% if is_incremental() %}
        where oh.ORDER_TS > (select max(ORDER_TS) from {{ this }})
    {% endif %}
    group by oh.ORDER_ID
),

aggregated_data as (
    select
        od.date_key,
        od.truck_key,
        od.location_key,
        
        -- Aggregated metrics per date/truck/location
        count(distinct od.ORDER_ID) as order_count,
        sum(odd.gross_sales_usd) as gross_sales_usd,
        sum(odd.net_sales_usd) as net_sales_usd
        
    from order_data od
    inner join order_detail_data odd
        on od.ORDER_ID = odd.ORDER_ID
    group by 
        od.date_key,
        od.truck_key, 
        od.location_key
)

select
    cast(date_key as string) as date_key,
    cast(truck_key as integer) as truck_key,
    cast(location_key as integer) as location_key,
    cast(order_count as integer) as order_count,
    cast(gross_sales_usd as decimal(10,2)) as gross_sales_usd,
    cast(net_sales_usd as decimal(10,2)) as net_sales_usd
    
from aggregated_data