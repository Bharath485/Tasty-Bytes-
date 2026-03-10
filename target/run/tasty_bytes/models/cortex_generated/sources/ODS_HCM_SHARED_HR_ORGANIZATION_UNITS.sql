
  
    

create or replace transient table DBT_POC.DEV.ODS_HCM_SHARED_HR_ORGANIZATION_UNITS
    
    
    
    as (

SELECT column1 AS ORGANIZATION_ID, column2 AS NAME
FROM VALUES
(701, 'Semiconductor Division'),
(702, 'PCB Assembly Unit')
    )
;


  