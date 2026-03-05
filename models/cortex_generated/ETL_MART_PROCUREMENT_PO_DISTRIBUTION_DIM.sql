/*--------------------------------------------------------------------------------------------
Command to run model:
--dbt run --select ETL_MART_PROCUREMENT_PO_DISTRIBUTION_DIM
--dbt build --full-refresh --select +ETL_MART_PROCUREMENT_PO_DISTRIBUTION_DIM
--dbt build --select ETL_MART_PROCUREMENT_PO_DISTRIBUTION_DIM --vars 'is_backfill: True'

Version     Date            Author                Description
-------     ----------      ----------------      ----------------------------------
1.0         2026-03-05      Cortex Code           Initial Version - Auto-Generated from STTM

----------------------------------------------------------------------------------------------*/

{################# EDW Job Template Variables #################}
{%-set v_pk_list = ['PO_DISTRIBUTION_KEY']-%}
{% if is_incremental() %}
{%-set v_house_keeping_column = ['BIW_INS_DTTM','BIW_UPD_DTTM','BIW_BATCH_ID','BIW_MD5_KEY']-%}
{%-set v_all_column_list =  edw_get_column_list( this ) -%}
{%-set v_update_column_list =  edw_get_quoted_column_list( this ,v_pk_list|list + ['BIW_INS_DTTM']|list) -%}
{% endif %}

{################# Batch control insert and update SQL #################}
{%- set v_dbt_job_name = 'DBT_ETL_MART_PROCUREMENT_PO_DISTRIBUTION_DIM'-%}
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
        description = 'Building ETL MART table for PO_DISTRIBUTION_DIM',
        transient=true,
        materialized='table',
        schema ='ETL_MART_PROCUREMENT',
        alias='PO_DISTRIBUTION_DIM',
        tags =['MART_PROCUREMENT'],
        unique_key= v_pk_list,
        post_hook= [v_sql_upd_success_batch]  
    )
}}

{################# CTE Definitions #################}

WITH PO_DISTRIBUTIONS_ALL AS (
    SELECT 
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
        WIP_OPERATION_SEQ_NUM,
        WIP_REPETITIVE_SCHEDULE_ID,
        WIP_RESOURCE_SEQ_NUM,
        PREVENT_ENCUMBRANCE_FLAG
    FROM {{ref('ODS_ORACLE_CLOUD_PO_DISTRIBUTIONS_ALL')}}
    WHERE 
        IS_DELETE = 'N'
        AND {% if var('is_backfill', false) %}
                BIW_UPD_DTTM >= '{{var('refresh_start_ts')}}'
            AND BIW_UPD_DTTM < '{{V_START_DTTM}}'
            {% else %}
                BIW_UPD_DTTM >= '{{V_LWM}}' 
            AND BIW_UPD_DTTM <= '{{V_HWM}}'
            {% endif %}
)

,PJF_PROJECTS_ALL_B AS (
    SELECT 
        PROJECT_ID,
        SEGMENT1 AS PROJECT_NUMBER
    FROM {{ref('ODS_ORACLE_CLOUD_PJF_PROJECTS_ALL_B')}}
    WHERE IS_DELETE = 'N'
)

,PJF_PROJECTS_ALL_TL AS (
    SELECT 
        PROJECT_ID,
        NAME AS PROJECT_NAME,
        LANGUAGE
    FROM {{ref('ODS_ORACLE_CLOUD_PJF_PROJECTS_ALL_TL')}}
    WHERE LANGUAGE = 'US'
)

,PJF_PROJECTS AS (
    SELECT 
        B.PROJECT_ID,
        B.PROJECT_NUMBER,
        TL.PROJECT_NAME
    FROM PJF_PROJECTS_ALL_B B
    LEFT OUTER JOIN PJF_PROJECTS_ALL_TL TL
        ON B.PROJECT_ID = TL.PROJECT_ID
)

,PJF_PROJ_ELEMENTS_B AS (
    SELECT 
        PROJECT_ID,
        PROJ_ELEMENT_ID,
        ELEMENT_NUMBER AS TASK_NUMBER
    FROM {{ref('ODS_ORACLE_CLOUD_PJF_PROJ_ELEMENTS_B')}}
    WHERE IS_DELETE = 'N'
)

,PJF_PROJ_ELEMENTS_TL AS (
    SELECT 
        PROJ_ELEMENT_ID,
        NAME AS TASK_NAME,
        LANGUAGE
    FROM {{ref('ODS_ORACLE_CLOUD_PJF_PROJ_ELEMENTS_TL')}}
    WHERE LANGUAGE = 'US'
)

,PJF_PROJ_ELEMENTS AS (
    SELECT 
        B.PROJECT_ID,
        B.PROJ_ELEMENT_ID,
        B.TASK_NUMBER,
        TL.TASK_NAME
    FROM PJF_PROJ_ELEMENTS_B B
    LEFT OUTER JOIN PJF_PROJ_ELEMENTS_TL TL
        ON B.PROJ_ELEMENT_ID = TL.PROJ_ELEMENT_ID
)

{################# Final SELECT #################}

SELECT 
    -- Primary Key
    MD5(OBJECT_CONSTRUCT(
        'COL1', POD.PO_DISTRIBUTION_ID::STRING
    )::STRING)::STRING AS PO_DISTRIBUTION_KEY,
    
    -- Business Columns
    POD.PO_DISTRIBUTION_ID,
    POD.DISTRIBUTION_NUM,
    POD.PO_HEADER_ID,
    POD.PO_LINE_ID,
    POD.LINE_LOCATION_ID,
    POD.REQ_DISTRIBUTION_ID,
    POD.WIP_ENTITY_ID,
    POD.BUDGET_DATE,
    POD.CANCEL_BUDGET_DATE,
    POD.CLOSE_BUDGET_DATE,
    POD.CREATION_DATE,
    POD.LAST_UPDATE_DATE,
    POD.RATE_DATE,
    POD.SET_OF_BOOKS_ID,
    POD.DELIVER_TO_LOCATION_ID,
    POD.CODE_COMBINATION_ID,
    POD.DELIVER_TO_PERSON_ID,
    POD.REQ_HEADER_REFERENCE_NUM,
    POD.REQ_LINE_REFERENCE_NUM,
    POD.PRC_BU_ID,
    POD.REQ_BU_ID,
    POD.WIP_LINE_ID,
    POD.DESTINATION_ORGANIZATION_ID,
    POD.SOLDTO_BU_ID,
    POD.DESTINATION_TYPE_CODE,
    POD.RATE,
    POD.DESTINATION_SUBINVENTORY,
    POD.DESTINATION_CONTEXT,
    POD.DISTRIBUTION_TYPE,
    POD.INVOICE_ADJUSTMENT_FLAG,
    POD.ACCRUED_FLAG,
    POD.ENCUMBERED_FLAG,
    POD.ACCRUE_ON_RECEIPT_FLAG,
    POD.PJC_PROJECT_ID,
    POD.PJC_TASK_ID,
    PRJ.PROJECT_NUMBER,
    PRJ.PROJECT_NAME,
    TSK.TASK_NUMBER,
    TSK.TASK_NAME,
    POD.WIP_OPERATION_SEQ_NUM,
    POD.WIP_REPETITIVE_SCHEDULE_ID,
    POD.WIP_RESOURCE_SEQ_NUM,
    POD.PREVENT_ENCUMBRANCE_FLAG,
    
    -- Housekeeping Columns
    'N'::BOOLEAN AS IS_DELETE,
    '{{V_START_DTTM}}'::TIMESTAMP_NTZ AS BIW_INS_DTTM,
    '{{V_START_DTTM}}'::TIMESTAMP_NTZ AS BIW_UPD_DTTM,
    '{{V_BIW_BATCH_ID}}'::NUMBER(38,0) AS BIW_BATCH_ID,
    MD5(OBJECT_CONSTRUCT(
        'COL1', POD.PO_DISTRIBUTION_ID::STRING,
        'COL2', POD.DISTRIBUTION_NUM::STRING,
        'COL3', POD.PO_HEADER_ID::STRING,
        'COL4', POD.PO_LINE_ID::STRING,
        'COL5', POD.LINE_LOCATION_ID::STRING,
        'COL6', POD.REQ_DISTRIBUTION_ID::STRING,
        'COL7', POD.WIP_ENTITY_ID::STRING,
        'COL8', POD.BUDGET_DATE::STRING,
        'COL9', POD.CANCEL_BUDGET_DATE::STRING,
        'COL10', POD.CLOSE_BUDGET_DATE::STRING,
        'COL11', POD.CREATION_DATE::STRING,
        'COL12', POD.LAST_UPDATE_DATE::STRING,
        'COL13', POD.RATE_DATE::STRING,
        'COL14', POD.SET_OF_BOOKS_ID::STRING,
        'COL15', POD.DELIVER_TO_LOCATION_ID::STRING,
        'COL16', POD.CODE_COMBINATION_ID::STRING,
        'COL17', POD.DELIVER_TO_PERSON_ID::STRING,
        'COL18', POD.REQ_HEADER_REFERENCE_NUM::STRING,
        'COL19', POD.REQ_LINE_REFERENCE_NUM::STRING,
        'COL20', POD.PRC_BU_ID::STRING,
        'COL21', POD.REQ_BU_ID::STRING,
        'COL22', POD.WIP_LINE_ID::STRING,
        'COL23', POD.DESTINATION_ORGANIZATION_ID::STRING,
        'COL24', POD.SOLDTO_BU_ID::STRING,
        'COL25', POD.DESTINATION_TYPE_CODE::STRING,
        'COL26', POD.RATE::STRING,
        'COL27', POD.DESTINATION_SUBINVENTORY::STRING,
        'COL28', POD.DESTINATION_CONTEXT::STRING,
        'COL29', POD.DISTRIBUTION_TYPE::STRING,
        'COL30', POD.INVOICE_ADJUSTMENT_FLAG::STRING,
        'COL31', POD.ACCRUED_FLAG::STRING,
        'COL32', POD.ENCUMBERED_FLAG::STRING,
        'COL33', POD.ACCRUE_ON_RECEIPT_FLAG::STRING,
        'COL34', POD.PJC_PROJECT_ID::STRING,
        'COL35', POD.PJC_TASK_ID::STRING,
        'COL36', PRJ.PROJECT_NUMBER::STRING,
        'COL37', PRJ.PROJECT_NAME::STRING,
        'COL38', TSK.TASK_NUMBER::STRING,
        'COL39', TSK.TASK_NAME::STRING,
        'COL40', POD.WIP_OPERATION_SEQ_NUM::STRING,
        'COL41', POD.WIP_REPETITIVE_SCHEDULE_ID::STRING,
        'COL42', POD.WIP_RESOURCE_SEQ_NUM::STRING,
        'COL43', POD.PREVENT_ENCUMBRANCE_FLAG::STRING,
        'COL44', 'N'::STRING
    )::STRING)::BINARY AS BIW_MD5_KEY

FROM PO_DISTRIBUTIONS_ALL POD
LEFT OUTER JOIN PJF_PROJECTS PRJ
    ON POD.PJC_PROJECT_ID = PRJ.PROJECT_ID
LEFT OUTER JOIN PJF_PROJ_ELEMENTS TSK
    ON POD.PJC_PROJECT_ID = TSK.PROJECT_ID
    AND POD.PJC_TASK_ID = TSK.PROJ_ELEMENT_ID
