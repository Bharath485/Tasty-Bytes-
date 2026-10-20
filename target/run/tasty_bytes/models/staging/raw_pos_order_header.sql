
  create or replace   view DBT_PROJECTS_TASTY_BYTES_DEV.DEV.raw_pos_order_header
  
  
  
  
  as (
    SELECT *
FROM DBT_PROJECTS_TASTY_BYTES_DEV.RAW.ORDER_HEADER
  );

