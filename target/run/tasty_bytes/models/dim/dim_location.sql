
  
    

create or replace transient table DBT_POC.DEV.DIM_LOCATION
    
    
    
    as (

-- Minimal conformed attributes for lookups
select
  LOCATION_ID as location_key,   -- surrogate (simple) matches natural id
  LOCATION_ID as location_id,    -- natural key retained for joins
  PLACEKEY,
  LOCATION,
  CITY,
  REGION,
  ISO_COUNTRY_CODE,
  COUNTRY
from DBT_POC.DEV.raw_pos_location
    )
;


  