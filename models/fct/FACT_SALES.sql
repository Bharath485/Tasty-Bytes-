{{ config(materialized='incremental', unique_key='order_item_id') }}

with order_detail_source as (
    select
        ORDER_DETAIL_ID,
        ORDER_ID,
        QUANTITY,
        UNIT_PRICE,
        PRICE,
        ORDER_ITEM_DISCOUNT_AMOUNT,
        DISCOUNT_ID
    from {{ source('tb_101', 'ORDER_DETAIL') }}
    {% if is_incremental() %}
        where ORDER_DETAIL_ID > (select max(order_item_id) from {{ this }})
    {% endif %}
),

order_header_source as (
    select
        ORDER_ID,
        ORDER_TS,
        LOCATION_ID,
        TRUCK_ID,
        CUSTOMER_ID,
        ORDER_TAX_AMOUNT,
        ORDER_CHANNEL,
        ORDER_CURRENCY
    from {{ source('tb_101', 'ORDER_HEADER') }}
),

final as (
    select
        cast(od.ORDER_DETAIL_ID as integer) as order_item_id,
        cast(od.ORDER_ID as integer) as order_id,
        cast(oh.ORDER_TS as timestamp) as order_ts,
        cast(to_number(to_char(oh.ORDER_TS, 'YYYYMMDD')) as integer) as order_date_key,
        cast(oh.LOCATION_ID as integer) as location_key,
        cast(oh.TRUCK_ID as integer) as truck_key,
        cast(oh.CUSTOMER_ID as integer) as customer_key,
        cast(greatest(od.QUANTITY, 0) as decimal(10,2)) as quantity,
        cast(coalesce(od.UNIT_PRICE, 0) as decimal(10,2)) as unit_price,
        cast(od.PRICE as decimal(10,2)) as line_gross_amount,
        cast(coalesce(od.ORDER_ITEM_DISCOUNT_AMOUNT, 0) as decimal(10,2)) as line_discount_amount,
        cast(od.PRICE - coalesce(od.ORDER_ITEM_DISCOUNT_AMOUNT, 0) as decimal(10,2)) as line_net_amount,
        cast(oh.ORDER_TAX_AMOUNT as decimal(10,2)) as header_tax_amount,
        cast(trim(upper(oh.ORDER_CHANNEL)) as varchar(50)) as order_channel,
        cast(upper(oh.ORDER_CURRENCY) as varchar(3)) as order_currency,
        cast(od.DISCOUNT_ID as integer) as discount_id,
        cast(current_timestamp() as timestamp) as dw_insert_ts,
        cast(current_timestamp() as timestamp) as dw_update_ts
    from order_detail_source od
    left join order_header_source oh
        on od.ORDER_ID = oh.ORDER_ID
)

select * from final