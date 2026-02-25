{{ config(
    materialized='incremental',
    unique_key='order_item_id'
) }}

with order_detail_source as (
    select
        order_detail_id,
        order_id,
        quantity,
        unit_price,
        price,
        order_item_discount_amount,
        discount_id
    from {{ source('tb_101', 'ORDER_DETAIL') }}
    {% if is_incremental() %}
        where order_detail_id > (select max(order_item_id) from {{ this }})
    {% endif %}
),

order_header_source as (
    select
        order_id,
        order_ts,
        location_id,
        truck_id,
        customer_id,
        order_tax_amount,
        order_channel,
        order_currency
    from {{ source('tb_101', 'ORDER_HEADER') }}
),

joined_data as (
    select
        -- Primary identifiers
        cast(od.order_detail_id as number) as order_item_id,
        cast(od.order_id as number) as order_id,
        
        -- Date and time columns
        cast(oh.order_ts as timestamp) as order_ts,
        cast(to_char(oh.order_ts, 'YYYYMMDD') as number) as order_date_key,
        
        -- Dimension keys (lookups to be resolved by dimension tables)
        cast(oh.location_id as number) as location_key,
        cast(oh.truck_id as number) as truck_key,
        cast(oh.customer_id as number) as customer_key,
        
        -- Quantity and pricing measures
        cast(case when od.quantity < 0 then 0 else od.quantity end as number) as quantity,
        cast(coalesce(od.unit_price, 0) as number(10,2)) as unit_price,
        cast(od.price as number(10,2)) as line_gross_amount,
        cast(coalesce(od.order_item_discount_amount, 0) as number(10,2)) as line_discount_amount,
        cast(od.price - coalesce(od.order_item_discount_amount, 0) as number(10,2)) as line_net_amount,
        
        -- Header level amounts
        cast(oh.order_tax_amount as number(10,2)) as header_tax_amount,
        
        -- Descriptive attributes
        cast(trim(upper(oh.order_channel)) as varchar(50)) as order_channel,
        cast(upper(oh.order_currency) as varchar(3)) as order_currency,
        cast(od.discount_id as number) as discount_id,
        
        -- System timestamps
        current_timestamp() as dw_insert_ts,
        current_timestamp() as dw_update_ts
        
    from order_detail_source od
    left join order_header_source oh
        on od.order_id = oh.order_id
)

select * from joined_data