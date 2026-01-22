
  create or replace   view tasty_bytes_dbt_db.DEV.raw_customer_customer_loyalty
  
  
  
  
  as (
    select *
from tasty_bytes_dbt_db.RAW.CUSTOMER_LOYALTY
  );

