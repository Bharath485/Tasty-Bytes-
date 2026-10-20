{{
    config(
        materialized='incremental',
        unique_key='ORDER_ID',
        incremental_strategy='merge'
    )
}}

-- FACT_ORDER: one row per order; line-level measures aggregated from ORDER_DETAIL.
-- SCD: not applicable (fact table); incremental merge on ORDER_ID (Type 1 overwrite).

with order_header as (

    select
        cast(ORDER_ID as integer)  as ORDER_ID,
        cast(ORDER_TS as timestamp) as ORDER_TIMESTAMP
    from {{ source('raw', 'ORDER_HEADER') }}
    {% if is_incremental() %}
    where cast(ORDER_TS as timestamp) > (select coalesce(max(ORDER_TIMESTAMP), '1900-01-01'::timestamp) from {{ this }})
    {% endif %}

),

order_detail_agg as (

    select
        cast(ORDER_ID as integer) as ORDER_ID,
        sum(PRICE)                as TOTAL_LINE_AMOUNT,
        sum(QUANTITY)             as TOTAL_QUANTITY
    from {{ source('raw', 'ORDER_DETAIL') }}
    group by cast(ORDER_ID as integer)

)

select
    h.ORDER_ID,
    h.ORDER_TIMESTAMP,
    cast(coalesce(d.TOTAL_LINE_AMOUNT, 0) as numeric(38, 2)) as TOTAL_LINE_AMOUNT,
    cast(coalesce(d.TOTAL_QUANTITY, 0) as integer)           as TOTAL_QUANTITY
from order_header h
left join order_detail_agg d
    on h.ORDER_ID = d.ORDER_ID
