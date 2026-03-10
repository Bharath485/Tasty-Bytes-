
  
    

create or replace transient table DBT_POC.DEV.ODS_HCM_SHARED_HR_LOCATIONS_ALL
    
    
    
    as (

SELECT column1 AS LOCATION_ID, column2 AS LOCATION_CODE
FROM VALUES
(4001, 'PHX-AZ-PLANT1'),
(4002, 'POCATELLO-ID'),
(4003, 'GRESHAM-OR')
    )
;


  