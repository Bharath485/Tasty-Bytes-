
  
    

create or replace transient table DBT_PROJECTS_TASTY_BYTES_DEV.dim.DIM_LOCATION
    
    
    
    
    

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
from DBT_PROJECTS_TASTY_BYTES_DEV.DEV.raw_pos_location
    )
;


  