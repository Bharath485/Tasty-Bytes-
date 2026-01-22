
  
    

create or replace transient table tasty_bytes_dbt_db.DEV.country
    
    
    
    as (with conuntry_mart as (
    select * from tasty_bytes_dbt_db.RAW.COUNTRY 
)

select * from conuntry_mart
    )
;


  