
  
    

create or replace transient table DBT_PROJECTS_TASTY_BYTES_DEV.mart.country
    
    
    
    
    

    as (with conuntry_mart as (
    select * from DBT_PROJECTS_TASTY_BYTES_DEV.RAW.COUNTRY 
)

select * from conuntry_mart
    )
;


  