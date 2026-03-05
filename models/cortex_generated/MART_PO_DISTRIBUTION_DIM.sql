/*---------------------------------------------------------------------------
  Model: MART_PO_DISTRIBUTION_DIM
  Layer: MART
  Type: DIM TABLE (SCD1)
  Primary Key: PO_DISTRIBUTION_KEY
  Natural Key: PO_DISTRIBUTION_ID
  Source Tables: 5
  Generated: STTM-to-dbt Auto-Generation (Enterprise Pattern)
---------------------------------------------------------------------------*/

{{
    config(
        materialized = 'incremental',
        unique_key = 'PO_DISTRIBUTION_KEY',
        on_schema_change = 'append_new_columns',
        transient = false,
        tags = ['MART', 'PROCUREMENT', 'PO_DISTRIBUTION'],
        post_hook = [
            "{{ edw_batch_control_post_hook() }}"
        ]
    )
}}

{%- set v_lwm = edw_batch_control('V_LWM') -%}
{%- set v_hwm = edw_batch_control('V_HWM') -%}
{%- set v_start_dttm = edw_batch_control('V_START_DTTM') -%}
{%- set v_biw_batch_id = edw_batch_control('V_BIW_BATCH_ID') -%}

{%- set is_backfill = var('is_backfill', false) -%}
{%- set refresh_start_ts = var('refresh_start_ts', '1900-01-01') -%}

{%- set md5_columns = [
    'PO_DISTRIBUTION_ID', 'DISTRIBUTION_NUM', 'PO_HEADER_ID', 'PO_LINE_ID', 'LINE_LOCATION_ID',
    'REQ_DISTRIBUTION_ID', 'WIP_ENTITY_ID', 'BUDGET_DATE', 'CANCEL_BUDGET_DATE', 'CLOSE_BUDGET_DATE',
    'CREATION_DATE', 'LAST_UPDATE_DATE', 'RATE_DATE', 'SET_OF_BOOKS_ID', 'DELIVER_TO_LOCATION_ID',
    'CODE_COMBINATION_ID', 'DELIVER_TO_PERSON_ID', 'REQ_HEADER_REFERENCE_NUM', 'REQ_LINE_REFERENCE_NUM',
    'PRC_BU_ID', 'REQ_BU_ID', 'WIP_LINE_ID', 'DESTINATION_ORGANIZATION_ID', 'SOLDTO_BU_ID',
    'DESTINATION_TYPE_CODE', 'RATE', 'DESTINATION_SUBINVENTORY', 'DESTINATION_CONTEXT', 'DISTRIBUTION_TYPE',
    'INVOICE_ADJUSTMENT_FLAG', 'ACCRUED_FLAG', 'ENCUMBERED_FLAG', 'ACCRUE_ON_RECEIPT_FLAG',
    'PJC_PROJECT_ID', 'PJC_TASK_ID', 'PROJECT_NUMBER', 'PROJECT_NAME', 'TASK_NUMBER', 'TASK_NAME',
    'WIP_OPERATION_SEQ_NUM', 'WIP_REPETITIVE_SCHEDULE_ID', 'WIP_RESOURCE_SEQ_NUM', 'PREVENT_ENCUMBRANCE_FLAG'
] -%}

/*---------------------------------------------------------------------------
  Source CTEs - One CTE per source table
---------------------------------------------------------------------------*/

WITH PO_DISTRIBUTIONS_ALL AS (
    SELECT *
    FROM {{ ref('PO_DISTRIBUTIONS_ALL') }}
    WHERE COALESCE(IS_DELETE, FALSE) = FALSE
    {% if is_incremental() and not is_backfill %}
        AND BIW_UPD_DTTM >= '{{ v_lwm }}'
        AND BIW_UPD_DTTM < '{{ v_hwm }}'
    {% elif is_backfill %}
        AND BIW_UPD_DTTM >= '{{ refresh_start_ts }}'
    {% endif %}
),

PJF_PROJECTS_ALL_B AS (
    SELECT *
    FROM {{ ref('PJF_PROJECTS_ALL_B') }}
    WHERE COALESCE(IS_DELETE, FALSE) = FALSE
),

PJF_PROJECTS_ALL_TL AS (
    SELECT *
    FROM {{ ref('PJF_PROJECTS_ALL_TL') }}
    WHERE COALESCE(IS_DELETE, FALSE) = FALSE
    AND LANGUAGE = 'US'
),

PJF_PROJ_ELEMENTS_B AS (
    SELECT *
    FROM {{ ref('PJF_PROJ_ELEMENTS_B') }}
    WHERE COALESCE(IS_DELETE, FALSE) = FALSE
),

PJF_PROJ_ELEMENTS_TL AS (
    SELECT *
    FROM {{ ref('PJF_PROJ_ELEMENTS_TL') }}
    WHERE COALESCE(IS_DELETE, FALSE) = FALSE
    AND LANGUAGE = 'US'
),

/*---------------------------------------------------------------------------
  Transformation CTE - Joins all source CTEs
---------------------------------------------------------------------------*/

TRANSFORMED AS (
    SELECT
        /* Primary Key */
        MD5(CAST(PDA.PO_DISTRIBUTION_ID AS VARCHAR)) AS PO_DISTRIBUTION_KEY,
        
        /* Natural Key */
        PDA.PO_DISTRIBUTION_ID,
        
        /* Business Columns */
        PDA.DISTRIBUTION_NUM,
        PDA.PO_HEADER_ID,
        PDA.PO_LINE_ID,
        PDA.LINE_LOCATION_ID,
        PDA.REQ_DISTRIBUTION_ID,
        PDA.WIP_ENTITY_ID,
        PDA.BUDGET_DATE,
        PDA.CANCEL_BUDGET_DATE,
        PDA.CLOSE_BUDGET_DATE,
        PDA.CREATION_DATE,
        PDA.LAST_UPDATE_DATE,
        PDA.RATE_DATE,
        PDA.SET_OF_BOOKS_ID,
        PDA.DELIVER_TO_LOCATION_ID,
        PDA.CODE_COMBINATION_ID,
        PDA.DELIVER_TO_PERSON_ID,
        PDA.REQ_HEADER_REFERENCE_NUM,
        PDA.REQ_LINE_REFERENCE_NUM,
        PDA.PRC_BU_ID,
        PDA.REQ_BU_ID,
        PDA.WIP_LINE_ID,
        PDA.DESTINATION_ORGANIZATION_ID,
        PDA.SOLDTO_BU_ID,
        PDA.DESTINATION_TYPE_CODE,
        PDA.RATE,
        PDA.DESTINATION_SUBINVENTORY,
        PDA.DESTINATION_CONTEXT,
        PDA.DISTRIBUTION_TYPE,
        PDA.INVOICE_ADJUSTMENT_FLAG,
        PDA.ACCRUED_FLAG,
        PDA.ENCUMBERED_FLAG,
        PDA.ACCRUE_ON_RECEIPT_FLAG,
        PDA.PJC_PROJECT_ID,
        PDA.PJC_TASK_ID,
        PJPB.SEGMENT1 AS PROJECT_NUMBER,
        PJPTL.NAME AS PROJECT_NAME,
        PJEB.ELEMENT_NUMBER AS TASK_NUMBER,
        PJETL.NAME AS TASK_NAME,
        PDA.WIP_OPERATION_SEQ_NUM,
        PDA.WIP_REPETITIVE_SCHEDULE_ID,
        PDA.WIP_RESOURCE_SEQ_NUM,
        PDA.PREVENT_ENCUMBRANCE_FLAG
        
    FROM PO_DISTRIBUTIONS_ALL PDA
    LEFT JOIN PJF_PROJECTS_ALL_B PJPB
        ON PDA.PJC_PROJECT_ID = PJPB.PROJECT_ID
    LEFT JOIN PJF_PROJECTS_ALL_TL PJPTL
        ON PDA.PJC_PROJECT_ID = PJPTL.PROJECT_ID
    LEFT JOIN PJF_PROJ_ELEMENTS_B PJEB
        ON PDA.PJC_TASK_ID = PJEB.PROJ_ELEMENT_ID
    LEFT JOIN PJF_PROJ_ELEMENTS_TL PJETL
        ON PDA.PJC_TASK_ID = PJETL.PROJ_ELEMENT_ID
),

/*---------------------------------------------------------------------------
  Final CTE with Housekeeping Columns
---------------------------------------------------------------------------*/

FINAL AS (
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
        /* Housekeeping Columns */
        FALSE AS IS_DELETE,
        {% if is_incremental() %}
            (SELECT BIW_INS_DTTM FROM {{ this }} t WHERE t.PO_DISTRIBUTION_KEY = TRANSFORMED.PO_DISTRIBUTION_KEY) AS BIW_INS_DTTM,
        {% else %}
            CURRENT_TIMESTAMP::TIMESTAMP_NTZ AS BIW_INS_DTTM,
        {% endif %}
        CURRENT_TIMESTAMP::TIMESTAMP_NTZ AS BIW_UPD_DTTM,
        {{ v_biw_batch_id }} AS BIW_BATCH_ID,
        MD5(OBJECT_CONSTRUCT(
            {%- for col in md5_columns %}
            '{{ col }}', {{ col }}{{ ',' if not loop.last else '' }}
            {%- endfor %}
        )::VARCHAR) AS BIW_MD5_KEY
    FROM TRANSFORMED
)

SELECT * FROM FINAL
