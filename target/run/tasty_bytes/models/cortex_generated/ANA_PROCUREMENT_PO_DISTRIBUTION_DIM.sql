
  create or replace   view DBT_POC.ANA_PROCUREMENT.PO_DISTRIBUTION_DIM
  
  
  
  
  as (
    /*--------------------------------------------------------------------------------------------
Command to run model:
--dbt run --select ANA_PROCUREMENT_PO_DISTRIBUTION_DIM
--dbt build --full-refresh --select +ANA_PROCUREMENT_PO_DISTRIBUTION_DIM
--dbt build --select ANA_PROCUREMENT_PO_DISTRIBUTION_DIM --vars 'is_backfill: True'

Version     Date            Author                Description
-------     ----------      ----------------      ----------------------------------
1.0         2026-03-05      Cortex Code           Initial Version - Auto-Generated from STTM

----------------------------------------------------------------------------------------------*/




SELECT 
    PO_DISTRIBUTION_KEY,
    PO_DISTRIBUTION_ID,
    DISTRIBUTION_NUM,
    PO_HEADER_ID,
    PO_LINE_ID,
    LINE_LOCATION_ID,
    REQ_DISTRIBUTION_ID,
    WIP_ENTITY_ID,
    BUDGET_DATE,
    CANCEL_BUDGET_DATE,
    CLOSE_BUDGET_DATE,
    CREATION_DATE,
    LAST_UPDATE_DATE,
    RATE_DATE,
    SET_OF_BOOKS_ID,
    DELIVER_TO_LOCATION_ID,
    CODE_COMBINATION_ID,
    DELIVER_TO_PERSON_ID,
    REQ_HEADER_REFERENCE_NUM,
    REQ_LINE_REFERENCE_NUM,
    PRC_BU_ID,
    REQ_BU_ID,
    WIP_LINE_ID,
    DESTINATION_ORGANIZATION_ID,
    SOLDTO_BU_ID,
    DESTINATION_TYPE_CODE,
    RATE,
    DESTINATION_SUBINVENTORY,
    DESTINATION_CONTEXT,
    DISTRIBUTION_TYPE,
    INVOICE_ADJUSTMENT_FLAG,
    ACCRUED_FLAG,
    ENCUMBERED_FLAG,
    ACCRUE_ON_RECEIPT_FLAG,
    PJC_PROJECT_ID,
    PJC_TASK_ID,
    PROJECT_NUMBER,
    PROJECT_NAME,
    TASK_NUMBER,
    TASK_NAME,
    WIP_OPERATION_SEQ_NUM,
    WIP_REPETITIVE_SCHEDULE_ID,
    WIP_RESOURCE_SEQ_NUM,
    PREVENT_ENCUMBRANCE_FLAG,
    BIW_INS_DTTM,
    BIW_UPD_DTTM,
    BIW_BATCH_ID,
    BIW_MD5_KEY

FROM DBT_POC.ETL_MART_PROCUREMENT.PO_DISTRIBUTION_DIM
  );

