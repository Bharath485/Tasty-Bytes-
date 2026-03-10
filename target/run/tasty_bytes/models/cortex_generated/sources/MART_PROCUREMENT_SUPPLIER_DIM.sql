
  
    

create or replace transient table DBT_POC.DEV.MART_PROCUREMENT_SUPPLIER_DIM
    
    
    
    as (

SELECT column1 AS VENDOR_ID, column2 AS SUPPLIER_NAME
FROM VALUES
(2001, 'Texas Instruments'),
(2002, 'Murata Manufacturing')
    )
;


  