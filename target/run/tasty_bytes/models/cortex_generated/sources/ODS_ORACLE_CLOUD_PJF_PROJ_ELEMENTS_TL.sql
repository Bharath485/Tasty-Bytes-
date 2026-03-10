
  
    

create or replace transient table DBT_POC.DEV.ODS_ORACLE_CLOUD_PJF_PROJ_ELEMENTS_TL
    
    
    
    as (

SELECT column1 AS PROJ_ELEMENT_ID, column2 AS NAME, column3 AS LANGUAGE
FROM VALUES
(9501, 'Design Phase', 'US'),
(9502, 'Build Phase', 'US')
    )
;


  