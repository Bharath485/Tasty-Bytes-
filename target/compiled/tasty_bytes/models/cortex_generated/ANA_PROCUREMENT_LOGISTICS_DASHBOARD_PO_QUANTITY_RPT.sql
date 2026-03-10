/*--------------------------------------------------------------------------------------------
Command to run model:
--dbt run --select ANA_PROCUREMENT_LOGISTICS_DASHBOARD_PO_QUANTITY_RPT
--dbt build --full-refresh --select +ANA_PROCUREMENT_LOGISTICS_DASHBOARD_PO_QUANTITY_RPT
--dbt build --select ANA_PROCUREMENT_LOGISTICS_DASHBOARD_PO_QUANTITY_RPT --vars 'is_backfill: True'

Version     Date            Author                Description
-------     ----------      ----------------      ----------------------------------
1.0         2026-03-06      Cortex Code           Initial Version - Auto-Generated from STTM

----------------------------------------------------------------------------------------------*/




SELECT 
    LOGISTICS_DASHBOARD_PO_QUANTITY_KEY,
    PO_HEADER_ID,
    PO_LINE_ID,
    LINE_LOCATION_ID,
    PO_NUMBER,
    LINE_NUM,
    PO_LINE_NUMBER,
    SHIPMENT_NUMBER,
    PO_NUM_LINE_SHIP,
    STATUS,
    SUPPLIER,
    SUPPLIER_SITE,
    ITEM_NUM,
    ITEM_DESCRIPTION,
    SUPPLIER_ITEM_NUM,
    DUE_DATE,
    PROMISED_DATE,
    LINE_CREATION_DATE,
    PO_APPROVED_DATE,
    PO_TYPE,
    CURRENCY_CODE,
    UNIT_MEAS_LOOKUP_CODE,
    SHIP_TO_LOCATION,
    AUTHORIZATION_STATUS,
    MATCHING_TYPE,
    PAST_DUE,
    BUYER,
    PLANNER_CODE,
    NAME,
    QUANTITY_DUE,
    QUANTITY_ORDERED,
    QUANTITY_RECEIVED,
    QUANTITY_BILLED,
    QUANTITY_CANCELLED,
    SHIPMENT_AMOUNT,
    BIW_INS_DTTM,
    BIW_UPD_DTTM,
    BIW_BATCH_ID,
    BIW_MD5_KEY

FROM DBT_POC.ETL_MART_PROCUREMENT.LOGISTICS_DASHBOARD_PO_QUANTITY_RPT