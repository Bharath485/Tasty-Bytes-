/*--------------------------------------------------------------------------------------------
Command to run model:
--dbt run --select ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM
--dbt build --full-refresh --select +ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM
--dbt build --select ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM --vars 'is_backfill: True'

Version     Date            Author                Description
-------     ----------      ----------------      ----------------------------------
1.0         2026-03-12      Cortex Code           Initial Version - Auto-Generated from STTM

----------------------------------------------------------------------------------------------*/

{################# EDW Job Template Variables #################}
{%-set v_pk_list = ['PO_DISTRIBUTION_KEY']-%}
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
        description = 'Building ETL MART table for PO_DISTRIBUTION_HIST_DIM',
        transient=true,
        materialized='incremental',
        schema ='ETL_MART_PROCUREMENT',
        alias='PO_DISTRIBUTION_HIST_DIM',
        tags =['PO'],
        unique_key= v_pk_list,
        merge_update_columns = ['BIW_UPD_DTTM','BIW_BATCH_ID','BIW_MD5_KEY','DBT_SCD_ID','DBT_UPDATED_AT','DBT_VALID_FROM','DBT_VALID_TO'],
        post_hook= [v_sql_upd_success_batch]  
    )
}}


{% snapshot po_distribution_hist_dim_snapshot %}

{{
    config(
        target_schema='ETL_MART_PROCUREMENT',
        unique_key='PO_DISTRIBUTION_KEY',
        strategy='check',
        check_cols='all',
        invalidate_hard_deletes=True
    )
}}

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
FROM {{ref('ETL_MART_PROCUREMENT_PO_DISTRIBUTION_DIM')}}
WHERE IS_DELETE = FALSE

{% endsnapshot %}
