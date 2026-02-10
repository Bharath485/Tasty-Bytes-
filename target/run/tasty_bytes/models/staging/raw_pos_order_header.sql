
  create or replace   view DBT_POC.DEV.raw_pos_order_header
  
  
  
  
  as (
    SELECT *
FROM dbt_poc.RAW.ORDER_HEADER
  );

