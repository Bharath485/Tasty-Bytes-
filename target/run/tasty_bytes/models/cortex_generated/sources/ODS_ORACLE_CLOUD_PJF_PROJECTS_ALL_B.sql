
  
    

create or replace transient table DBT_POC.DEV.ODS_ORACLE_CLOUD_PJF_PROJECTS_ALL_B
    
    
    
    as (

SELECT column1 AS PROJECT_ID, column2 AS SEGMENT1
FROM VALUES
(9001, 'PRJ-001'),
(9002, 'PRJ-002')
    )
;


  