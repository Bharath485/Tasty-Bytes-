
  
    

create or replace transient table DBT_POC.DEV.ODS_ORACLE_CLOUD_PJF_PROJECTS_ALL_TL
    
    
    
    as (

SELECT column1 AS PROJECT_ID, column2 AS NAME, column3 AS LANGUAGE
FROM VALUES
(9001, 'Alpha Project', 'US'),
(9002, 'Beta Project', 'US')
    )
;


  