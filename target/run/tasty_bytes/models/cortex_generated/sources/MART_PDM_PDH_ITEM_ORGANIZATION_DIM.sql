
  
    

create or replace transient table DBT_POC.DEV.MART_PDM_PDH_ITEM_ORGANIZATION_DIM
    
    
    
    as (

SELECT column1 AS INVENTORY_ITEM_ID, column2 AS ORGANIZATION_ID, column3 AS ITEM_NUMBER, column4 AS PLANNER_CODE
FROM VALUES
(3001, 701, 'CHIP-A100', 'PL-001'),
(3002, 701, 'RES-10K', 'PL-002'),
(3003, 702, 'PCB-V3', 'PL-003')
    )
;


  