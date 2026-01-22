
{{ config(materialized='table', alias='DIM_DATE') }}

-- Build a minimal calendar from ORDER_HEADER timestamps
with dates as (
  select distinct
    cast(date(ORDER_TS) as date) as calendar_date
  from {{ ref('raw_pos_order_header') }}
  where ORDER_TS is not null
)

select
  -- YYYYMMDD integer key exactly as required by the fact
  to_number(to_char(calendar_date, 'YYYYMMDD')) as date_key,
  calendar_date as date,
  extract(year  from calendar_date) as year,
  extract(month from calendar_date) as month,
  extract(day   from calendar_date) as day_of_month
from dates
order by calendar_date
