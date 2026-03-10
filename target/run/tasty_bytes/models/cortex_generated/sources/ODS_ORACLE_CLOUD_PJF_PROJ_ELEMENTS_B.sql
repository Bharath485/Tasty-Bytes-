
  
    

create or replace transient table DBT_POC.DEV.ODS_ORACLE_CLOUD_PJF_PROJ_ELEMENTS_B
    
    
    
    as (

SELECT column1 AS PROJECT_ID, column2 AS PROJ_ELEMENT_ID, column3 AS ELEMENT_NUMBER
FROM VALUES
(9001, 9501, 'TASK-001'),
(9002, 9502, 'TASK-002')
    )
;


  