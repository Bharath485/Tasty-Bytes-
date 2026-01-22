-- models/marts/sales/dim_customer.sql


with customers as (
    select
        -- natural key from source
        customer_id,
        -- standard conformed attributes
        initcap(trim(first_name))      as first_name,
        initcap(trim(last_name))       as last_name,
        lower(trim(e_mail))             as email,
        coalesce(country, 'Unknown')   as country,
        -- coalesce(state, 'Unknown')     as state,
        -- coalesce(city, 'Unknown')      as city,

        -- type 1 dimension pattern: latest snapshot from staging
        current_timestamp()            as dim_load_ts
    from tasty_bytes_dbt_db.DEV.raw_customer_customer_loyalty
)
select * from customers