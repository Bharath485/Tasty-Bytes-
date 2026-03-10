
  
    

create or replace transient table DBT_POC.DEV.MART_PROCUREMENT_PO_LINE_DIM
    
    
    
    as (

SELECT column1 AS PO_LINE_ID, column2 AS PO_HEADER_ID, column3 AS LINE_NUM, column4 AS ITEM_DESCRIPTION, column5 AS VENDOR_PRODUCT_NUM, column6 AS UOM_CODE
FROM VALUES
(3001, 2001, 1, 'Semiconductor Chip A100', 'VP-001', 'EA'),
(3002, 2001, 2, 'Resistor Pack 10K', 'VP-002', 'PK'),
(3003, 2002, 1, 'PCB Board v3', 'VP-003', 'EA')
    )
;


  