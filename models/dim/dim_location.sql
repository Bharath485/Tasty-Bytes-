
{{ config(materialized='table', alias='DIM_LOCATION') }}

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
from {{ ref('raw_pos_location') }}
