
{{ config(materialized='table', alias='DIM_TRUCK') }}

select
  TRUCK_ID as truck_key,
  TRUCK_ID as truck_id,
  MENU_TYPE_ID,
  PRIMARY_CITY,
  REGION,
  ISO_REGION,
  COUNTRY,
  ISO_COUNTRY_CODE,
  FRANCHISE_FLAG,
  YEAR,
  MAKE,
  MODEL,
  EV_FLAG,
  FRANCHISE_ID,
  TRUCK_OPENING_DATE
from {{ ref('raw_pos_truck') }}
