with order_detail_source as (
    select
        order_detail_id,
        order_id,
        quantity,
        unit_price,
        price,
        order_item_discount_amount,
        discount_id
    from tasty_bytes_dbt_db.DEV.ORDER_DETAIL
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
    from tasty_bytes_dbt_db.DEV.ORDER_HEADER
),
dim_date_lookup as (
    select
        date_key,
        date_key as date_value
    from tasty_bytes_dbt_db.DEV.DIM_DATE
),
dim_location_lookup as (
    select
        location_key,
        location_id
    from tasty_bytes_dbt_db.DEV.DIM_LOCATION
),
dim_truck_lookup as (
    select
        truck_key,
        truck_id
    from tasty_bytes_dbt_db.DEV.DIM_TRUCK
),
fact_orders as (
    select
        od.order_detail_id,
        od.order_id,
        oh.order_ts,
        cast(to_char(oh.order_ts, 'YYYYMMDD') as integer) as order_date_key,
        coalesce(dl.location_key, -1) as location_key,
        coalesce(dt.truck_key, -1) as truck_key,
        coalesce(dc.customer_key, -1) as customer_key,
        case 
            when cast(od.quantity as number) < 0 then 0
            else cast(od.quantity as number)
        end as quantity,
        coalesce(cast(od.unit_price as number), 0) as unit_price,
        cast(od.price as number) as line_gross_amount,
        coalesce(cast(od.order_item_discount_amount as number), 0) as line_discount_amount,
        cast(od.price as number) - coalesce(cast(od.order_item_discount_amount as number), 0) as line_net_amount,
        cast(oh.order_tax_amount as number) as header_tax_amount,
        trim(upper(oh.order_channel)) as order_channel,
        upper(oh.order_currency) as order_currency,
        od.discount_id,
        current_timestamp() as dw_insert_ts,
        current_timestamp() as dw_update_ts
    from order_detail_source od
    inner join order_header_source oh
        on od.order_id = oh.order_id
    left join dim_location_lookup dl
        on oh.location_id = dl.location_id
    left join dim_truck_lookup dt
        on oh.truck_id = dt.truck_id
    left join tasty_bytes_dbt_db.DEV.dim_customer dc
        on oh.customer_id = dc.customer_id
)
select 
    order_detail_id,
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
    line_net_amount,
    header_tax_amount,
    order_channel,
    order_currency,
    discount_id,
    dw_insert_ts,
    dw_update_ts
from fact_orders