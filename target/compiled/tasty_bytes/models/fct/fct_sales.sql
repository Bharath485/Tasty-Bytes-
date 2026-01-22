

with order_detail_source as (
    select
        order_detail_id,
        order_id,
        quantity,
        unit_price,
        price,
        order_item_discount_amount,
        discount_id
    from tasty_bytes_dbt_db.RAW.ORDER_DETAIL
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
    from tasty_bytes_dbt_db.RAW.ORDER_HEADER
),

dim_location as (
    select
        location_id,
        location_key
    from tasty_bytes_dbt_db.DEV.DIM_LOCATION
),

dim_truck as (
    select
        truck_id,
        truck_key
    from tasty_bytes_dbt_db.DEV.DIM_TRUCK
),

dim_customer as (
    select
        customer_id
    from tasty_bytes_dbt_db.DEV.dim_customers
),

joined_data as (
    select
        od.order_detail_id,
        od.order_id,
        oh.order_ts,
        cast(to_char(oh.order_ts, 'YYYYMMDD') as integer) as order_date_key,
        coalesce(dl.location_key, -1) as location_key,
        coalesce(dt.truck_key, -1) as truck_key,
        case 
            when cast(od.quantity as number) < 0 then 0 
            else cast(coalesce(od.quantity, 0) as number) 
        end as quantity,
        cast(coalesce(od.unit_price, 0) as number(10,2)) as unit_price,
        cast(coalesce(od.price, 0) as number(10,2)) as line_gross_amount,
        cast(coalesce(od.order_item_discount_amount, 0) as number(10,2)) as line_discount_amount,
        cast(coalesce(oh.order_tax_amount, 0) as number(10,2)) as header_tax_amount,
        upper(trim(oh.order_channel)) as order_channel,
        upper(oh.order_currency) as order_currency,
        od.discount_id,
        current_timestamp() as dw_insert_ts,
        current_timestamp() as dw_update_ts
    from order_detail_source od
    inner join order_header_source oh on od.order_id = oh.order_id
    left join dim_location dl on oh.location_id = dl.location_id
    left join dim_truck dt on oh.truck_id = dt.truck_id
    left join dim_customer dc on oh.customer_id = dc.customer_id
)

select
    order_detail_id as order_item_id,
    order_id,
    order_ts,
    order_date_key,
    location_key,
    truck_key,
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