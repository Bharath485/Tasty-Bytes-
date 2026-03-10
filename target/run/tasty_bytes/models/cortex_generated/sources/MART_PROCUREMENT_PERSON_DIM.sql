
  
    

create or replace transient table DBT_POC.DEV.MART_PROCUREMENT_PERSON_DIM
    
    
    
    as (

SELECT column1 AS PERSON_ID, column2 AS FULL_NAME
FROM VALUES
(501, 'John Smith'),
(502, 'Jane Doe')
    )
;


  