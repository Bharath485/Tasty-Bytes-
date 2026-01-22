{{ config(materialized='table') }}

with dim_customer_lookup as (
    select * from {{ ref('dim_customer') }}
),

dim_location_lookup as (
    select * from {{ ref('dim_location') }}
),

dim_truck_lookup as (
    select * from {{ ref('dim_truck') }}
),

order_header as (
    select * from {{ source('tb_101', 'ORDER_HEADER') }}
),

order_detail as (
    select * from {{ source('tb_101', 'ORDER_DETAIL') }}
)

select
    oh.order_id,
    oh.truck_id,
    oh.location_id,
    oh.customer_id,
    oh.discount_id,
    oh.shift_id,
    oh.shift_start_time,
    oh.shift_end_time,
    oh.order_channel,
    oh.order_ts,
    oh.served_ts,
    oh.order_currency,
    oh.order_amount,
    oh.order_tax_amount,
    oh.order_discount_amount,
    oh.order_total,
    od.order_detail_id,
    od.line_number,
    od.menu_item_id,
    od.quantity,
    od.unit_price,
    od.price,
    od.order_item_discount_amount
from order_header oh
join order_detail od on oh.order_id = od.order_id