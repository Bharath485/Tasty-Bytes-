

with order_detail_source as (
    select
        order_detail_id,
        order_id,
        quantity,
        unit_price,
        price,
        order_item_discount_amount,
        discount_id
    from dbt_poc.RAW.ORDER_DETAIL
    
        where order_detail_id > (select max(order_item_id) from DBT_POC.DEV.FACT_SALES)
    
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
    from dbt_poc.RAW.ORDER_HEADER
),

joined_data as (
    select
        od.order_detail_id,
        od.order_id,
        oh.order_ts,
        oh.location_id,
        oh.truck_id,
        oh.customer_id,
        cast(case when od.quantity < 0 then 0 else od.quantity end as numeric) as quantity,
        cast(coalesce(od.unit_price, 0) as numeric) as unit_price,
        cast(od.price as numeric) as line_gross_amount,
        cast(coalesce(od.order_item_discount_amount, 0) as numeric) as line_discount_amount,
        cast(oh.order_tax_amount as numeric) as header_tax_amount,
        upper(trim(oh.order_channel)) as order_channel,
        upper(oh.order_currency) as order_currency,
        od.discount_id
    from order_detail_source od
    inner join order_header_source oh
        on od.order_id = oh.order_id
)

select
    -- Primary identifiers
    cast(order_detail_id as varchar) as order_item_id,
    cast(order_id as varchar) as order_id,
    
    -- Date and time dimensions
    cast(order_ts as timestamp) as order_ts,
    cast(to_number(to_char(order_ts, 'YYYYMMDD')) as integer) as order_date_key,
    
    -- Dimension keys (lookups to be resolved via dimension tables)
    cast(location_id as varchar) as location_key,
    cast(truck_id as varchar) as truck_key,
    cast(customer_id as varchar) as customer_key,
    
    -- Measures
    quantity,
    unit_price,
    line_gross_amount,
    line_discount_amount,
    cast(line_gross_amount - coalesce(line_discount_amount, 0) as numeric) as line_net_amount,
    header_tax_amount,
    
    -- Attributes
    order_channel,
    order_currency,
    cast(discount_id as varchar) as discount_id,
    
    -- System metadata
    current_timestamp() as dw_insert_ts,
    current_timestamp() as dw_update_ts
    
from joined_data