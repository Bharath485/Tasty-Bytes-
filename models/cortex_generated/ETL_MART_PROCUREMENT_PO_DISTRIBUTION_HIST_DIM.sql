/*--------------------------------------------------------------------------------------------
Command to run model:
--dbt run --select ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM
--dbt build --full-refresh --select +ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM
--dbt build --select ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM --vars 'is_backfill: True'

Version     Date            Author                Description
-------     ----------      ----------------      ----------------------------------
1.0         2026-03-05      Cortex Code           Initial Version - Auto-Generated from STTM

----------------------------------------------------------------------------------------------*/

{################# EDW Job Template Variables #################}
{%-set v_pk_list = ['PO_DISTRIBUTION_KEY', 'DBT_SCD_ID']-%}
{% if is_incremental() %}
{%-set v_house_keeping_column = ['BIW_INS_DTTM','BIW_UPD_DTTM','BIW_BATCH_ID','BIW_MD5_KEY']-%}
{%-set v_all_column_list =  edw_get_column_list( this ) -%}
{%-set v_update_column_list =  edw_get_quoted_column_list( this ,v_pk_list|list + ['BIW_INS_DTTM']|list) -%}
{% endif %}

{################# Batch control insert and update SQL #################}
{%- set v_dbt_job_name = 'DBT_ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM'-%}
-- Step 1 Batch process info
{%- set v_watermark = edw_batch_control(v_dbt_job_name,config.get('schema'),config.get('alias'),config.get('tags'),config.get('materialized') ) -%}
{%- set V_LWM = v_watermark[0] -%}
{%- set V_HWM = v_watermark[1] -%}
{%- set V_START_DTTM = v_watermark[2] -%}
{%- set V_BIW_BATCH_ID = v_watermark[3] -%}
{%- set v_sql_upd_success_batch = "CALL UTILITY.EDW_BATCH_SUCCESS_PROC('"~v_dbt_job_name~"')" -%}

{################# Snowflake Object Configuration #################}
{{
    config(
        description = 'Building ETL MART SCD2 snapshot table for PO_DISTRIBUTION_HIST_DIM',
        transient=true,
        materialized='table',
        schema ='ETL_MART_PROCUREMENT',
        alias='PO_DISTRIBUTION_HIST_DIM',
        tags =['MART_PROCUREMENT'],
        unique_key= v_pk_list,
        post_hook= [v_sql_upd_success_batch]  
    )
}}

{################# CTE Definitions #################}

WITH PO_DISTRIBUTION_DIM AS (
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
        IS_DELETE,
        BIW_INS_DTTM,
        BIW_UPD_DTTM,
        BIW_BATCH_ID,
        BIW_MD5_KEY
    FROM {{ref('MART_PROCUREMENT_PO_DISTRIBUTION_DIM')}}
    WHERE 
        {% if var('is_backfill', false) %}
            BIW_UPD_DTTM >= '{{var('refresh_start_ts')}}'
        AND BIW_UPD_DTTM < '{{V_START_DTTM}}'
        {% else %}
            BIW_UPD_DTTM >= '{{V_LWM}}' 
        AND BIW_UPD_DTTM <= '{{V_HWM}}'
        {% endif %}
)

{################# Final SELECT #################}

SELECT 
    -- Business Columns (from source DIM)
    SRC.PO_DISTRIBUTION_KEY,
    SRC.PO_DISTRIBUTION_ID,
    SRC.DISTRIBUTION_NUM,
    SRC.PO_HEADER_ID,
    SRC.PO_LINE_ID,
    SRC.LINE_LOCATION_ID,
    SRC.REQ_DISTRIBUTION_ID,
    SRC.WIP_ENTITY_ID,
    SRC.BUDGET_DATE,
    SRC.CANCEL_BUDGET_DATE,
    SRC.CLOSE_BUDGET_DATE,
    SRC.CREATION_DATE,
    SRC.LAST_UPDATE_DATE,
    SRC.RATE_DATE,
    SRC.SET_OF_BOOKS_ID,
    SRC.DELIVER_TO_LOCATION_ID,
    SRC.CODE_COMBINATION_ID,
    SRC.DELIVER_TO_PERSON_ID,
    SRC.REQ_HEADER_REFERENCE_NUM,
    SRC.REQ_LINE_REFERENCE_NUM,
    SRC.PRC_BU_ID,
    SRC.REQ_BU_ID,
    SRC.WIP_LINE_ID,
    SRC.DESTINATION_ORGANIZATION_ID,
    SRC.SOLDTO_BU_ID,
    SRC.DESTINATION_TYPE_CODE,
    SRC.RATE,
    SRC.DESTINATION_SUBINVENTORY,
    SRC.DESTINATION_CONTEXT,
    SRC.DISTRIBUTION_TYPE,
    SRC.INVOICE_ADJUSTMENT_FLAG,
    SRC.ACCRUED_FLAG,
    SRC.ENCUMBERED_FLAG,
    SRC.ACCRUE_ON_RECEIPT_FLAG,
    SRC.PJC_PROJECT_ID,
    SRC.PJC_TASK_ID,
    SRC.PROJECT_NUMBER,
    SRC.PROJECT_NAME,
    SRC.TASK_NUMBER,
    SRC.TASK_NAME,
    SRC.WIP_OPERATION_SEQ_NUM,
    SRC.WIP_REPETITIVE_SCHEDULE_ID,
    SRC.WIP_RESOURCE_SEQ_NUM,
    SRC.PREVENT_ENCUMBRANCE_FLAG,
    
    -- Housekeeping Columns
    SRC.IS_DELETE,
    SRC.BIW_INS_DTTM,
    '{{V_START_DTTM}}'::TIMESTAMP_NTZ AS BIW_UPD_DTTM,
    '{{V_BIW_BATCH_ID}}'::NUMBER(38,0) AS BIW_BATCH_ID,
    SRC.BIW_MD5_KEY,
    
    -- SCD2 Columns
    MD5(OBJECT_CONSTRUCT(
        'COL1', SRC.PO_DISTRIBUTION_KEY::STRING,
        'COL2', '{{V_START_DTTM}}'::STRING
    )::STRING)::STRING AS DBT_SCD_ID,
    '{{V_START_DTTM}}'::DATE AS DBT_UPDATED_AT,
    '{{V_START_DTTM}}'::DATE AS DBT_VALID_FROM,
    '9999-12-31'::DATE AS DBT_VALID_TO

FROM PO_DISTRIBUTION_DIM SRC
