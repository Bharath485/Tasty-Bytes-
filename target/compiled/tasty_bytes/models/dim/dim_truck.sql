

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
from tasty_bytes_dbt_db.DEV.raw_pos_truck