{{ config(
    materialized='incremental',
    unique_key='order_item_id',
    on_schema_change='fail'
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
        od.order_detail_id,
        od.order_id,
        oh.order_ts,
        to_number(to_char(oh.order_ts, 'YYYYMMDD')) as order_date_key,
        oh.location_id as location_key,
        oh.truck_id as truck_key,
        oh.customer_id as customer_key,
        case 
            when od.quantity < 0 then 0 
            else cast(od.quantity as number) 
        end as quantity,
        coalesce(cast(od.unit_price as number), 0) as unit_price,
        cast(od.price as number) as line_gross_amount,
        coalesce(cast(od.order_item_discount_amount as number), 0) as line_discount_amount,
        cast(oh.order_tax_amount as number) as header_tax_amount,
        trim(upper(oh.order_channel)) as order_channel,
        upper(oh.order_currency) as order_currency,
        od.discount_id,
        current_timestamp() as dw_insert_ts,
        current_timestamp() as dw_update_ts
    from order_detail_source od
    inner join order_header_source oh
        on od.order_id = oh.order_id
    {% if is_incremental() %}
        where oh.order_ts > (select max(order_ts) from {{ this }})
    {% endif %}
)

select
    order_detail_id as order_item_id,
    order_id,
    order_ts,
    order_date_key,
    location_key,
    truck_key,
    customer_key,
    quantity,
    unit_price,
    line_gross_amount,
    line_discount_amount,
    line_gross_amount - coalesce(line_discount_amount, 0) as line_net_amount,
    header_tax_amount,
    order_channel,
    order_currency,
    discount_id,
    dw_insert_ts,
    dw_update_ts
from joined_data