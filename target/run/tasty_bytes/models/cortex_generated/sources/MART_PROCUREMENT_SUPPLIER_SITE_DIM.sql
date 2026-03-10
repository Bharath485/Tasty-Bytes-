
  
    

create or replace transient table DBT_POC.DEV.MART_PROCUREMENT_SUPPLIER_SITE_DIM
    
    
    
    as (

SELECT column1 AS VENDOR_SITE_ID, column2 AS SUPPLIER_SITE_CODE
FROM VALUES
(2001, 'DALLAS-TX'),
(2002, 'TOKYO-JP')
    )
;


  