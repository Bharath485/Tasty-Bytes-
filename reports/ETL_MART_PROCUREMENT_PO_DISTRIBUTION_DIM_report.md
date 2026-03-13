# STTM Generation Report: ETL_MART_PROCUREMENT_PO_DISTRIBUTION_DIM

| Property          | Value                                          |
|-------------------|------------------------------------------------|
| Sheet             | MART.PO_DISTRIBUTION_DIM                       |
| Database          | EDWPRD                                         |
| Schema            | MART_PROCUREMENT                               |
| Table             | PO_DISTRIBUTION_DIM                            |
| Table Type        | DIM TABLE (SCD1)                               |
| Primary Key       | PO_DISTRIBUTION_KEY                            |
| Natural Key       | PO_DISTRIBUTION_ID                             |
| Load Strategy     | MERGE                                          |
| Pattern           | Enterprise (ONSEMI)                            |
| Generated         | 2026-03-13                                     |
| Model File        | models/cortex_generated/ETL_MART_PROCUREMENT_PO_DISTRIBUTION_DIM.sql |

## Source Tables

| # | Source Schema      | Source Table             | CTE Name              | Join Type         |
|---|--------------------|--------------------------|-----------------------|-------------------|
| 1 | ODS_ORACLE_CLOUD  | PO_DISTRIBUTIONS_ALL     | PO_DISTRIBUTIONS_ALL  | Main Driver       |
| 2 | ODS_ORACLE_CLOUD  | PJF_PROJECTS_ALL_B       | PJF_PROJECTS_ALL_B    | LEFT OUTER JOIN   |
| 3 | ODS_ORACLE_CLOUD  | PJF_PROJECTS_ALL_TL      | PJF_PROJECTS_ALL_TL   | Pre-joined in CTE |
| 4 | ODS_ORACLE_CLOUD  | PJF_PROJ_ELEMENTS_B      | PJF_PROJ_ELEMENTS_B   | LEFT OUTER JOIN   |
| 5 | ODS_ORACLE_CLOUD  | PJF_PROJ_ELEMENTS_TL     | PJF_PROJ_ELEMENTS_TL  | Pre-joined in CTE |

## Column Mappings (49 columns)

| # | Target Column                | Data Type          | Key | Source Table             | Source Column              | ETL Rule                        |
|---|------------------------------|--------------------|-----|--------------------------|----------------------------|---------------------------------|
| 1 | PO_DISTRIBUTION_KEY          | VARCHAR(32)        | PK  | PO_DISTRIBUTIONS_ALL     | PO_DISTRIBUTION_ID         | MD5(PO_DISTRIBUTION_ID)         |
| 2 | PO_DISTRIBUTION_ID           | NUMBER             | NK  | PO_DISTRIBUTIONS_ALL     | PO_DISTRIBUTION_ID         | Direct                          |
| 3 | DISTRIBUTION_NUM             | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | DISTRIBUTION_NUM           | Direct                          |
| 4 | PO_HEADER_ID                 | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | PO_HEADER_ID               | Direct                          |
| 5 | PO_LINE_ID                   | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | PO_LINE_ID                 | Direct                          |
| 6 | LINE_LOCATION_ID             | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | LINE_LOCATION_ID           | Direct                          |
| 7 | REQ_DISTRIBUTION_ID          | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | REQ_DISTRIBUTION_ID        | Direct                          |
| 8 | WIP_ENTITY_ID                | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | WIP_ENTITY_ID              | Direct                          |
| 9 | BUDGET_DATE                  | DATE               |     | PO_DISTRIBUTIONS_ALL     | BUDGET_DATE                | Direct                          |
| 10| CANCEL_BUDGET_DATE           | DATE               |     | PO_DISTRIBUTIONS_ALL     | CANCEL_BUDGET_DATE         | Direct                          |
| 11| CLOSE_BUDGET_DATE            | DATE               |     | PO_DISTRIBUTIONS_ALL     | CLOSE_BUDGET_DATE          | Direct                          |
| 12| CREATION_DATE                | TIMESTAMP_NTZ(9)   |     | PO_DISTRIBUTIONS_ALL     | CREATION_DATE              | Direct                          |
| 13| LAST_UPDATE_DATE             | TIMESTAMP_NTZ(9)   |     | PO_DISTRIBUTIONS_ALL     | LAST_UPDATE_DATE           | Direct                          |
| 14| RATE_DATE                    | DATE               |     | PO_DISTRIBUTIONS_ALL     | RATE_DATE                  | Direct                          |
| 15| SET_OF_BOOKS_ID              | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | SET_OF_BOOKS_ID            | Direct                          |
| 16| DELIVER_TO_LOCATION_ID       | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | DELIVER_TO_LOCATION_ID     | Direct                          |
| 17| CODE_COMBINATION_ID          | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | CODE_COMBINATION_ID        | Direct                          |
| 18| DELIVER_TO_PERSON_ID         | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | DELIVER_TO_PERSON_ID       | Direct                          |
| 19| REQ_HEADER_REFERENCE_NUM     | VARCHAR(32)        |     | PO_DISTRIBUTIONS_ALL     | REQ_HEADER_REFERENCE_NUM   | Direct                          |
| 20| REQ_LINE_REFERENCE_NUM       | VARCHAR(32)        |     | PO_DISTRIBUTIONS_ALL     | REQ_LINE_REFERENCE_NUM     | Direct                          |
| 21| PRC_BU_ID                    | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | PRC_BU_ID                  | Direct                          |
| 22| REQ_BU_ID                    | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | REQ_BU_ID                  | Direct                          |
| 23| WIP_LINE_ID                  | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | WIP_LINE_ID                | Direct                          |
| 24| DESTINATION_ORGANIZATION_ID  | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | DESTINATION_ORGANIZATION_ID| Direct                          |
| 25| SOLDTO_BU_ID                 | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | SOLDTO_BU_ID               | Direct                          |
| 26| DESTINATION_TYPE_CODE        | VARCHAR(32)        |     | PO_DISTRIBUTIONS_ALL     | DESTINATION_TYPE_CODE      | Direct                          |
| 27| RATE                         | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | RATE                       | Direct                          |
| 28| DESTINATION_SUBINVENTORY     | VARCHAR(32)        |     | PO_DISTRIBUTIONS_ALL     | DESTINATION_SUBINVENTORY   | Direct                          |
| 29| DESTINATION_CONTEXT          | VARCHAR(32)        |     | PO_DISTRIBUTIONS_ALL     | DESTINATION_CONTEXT        | Direct                          |
| 30| DISTRIBUTION_TYPE            | VARCHAR(32)        |     | PO_DISTRIBUTIONS_ALL     | DISTRIBUTION_TYPE          | Direct                          |
| 31| INVOICE_ADJUSTMENT_FLAG      | VARCHAR(32)        |     | PO_DISTRIBUTIONS_ALL     | INVOICE_ADJUSTMENT_FLAG    | Direct                          |
| 32| ACCRUED_FLAG                 | BOOLEAN            |     | PO_DISTRIBUTIONS_ALL     | ACCRUED_FLAG               | Direct                          |
| 33| ENCUMBERED_FLAG              | BOOLEAN            |     | PO_DISTRIBUTIONS_ALL     | ENCUMBERED_FLAG            | Direct                          |
| 34| ACCRUE_ON_RECEIPT_FLAG       | BOOLEAN            |     | PO_DISTRIBUTIONS_ALL     | ACCRUE_ON_RECEIPT_FLAG     | Direct                          |
| 35| PJC_PROJECT_ID               | NUMBER(38,0)       |     | PO_DISTRIBUTIONS_ALL     | PJC_PROJECT_ID             | Direct                          |
| 36| PJC_TASK_ID                  | NUMBER(38,0)       |     | PO_DISTRIBUTIONS_ALL     | PJC_TASK_ID                | Direct                          |
| 37| PROJECT_NUMBER               | VARCHAR            |     | PJF_PROJECTS_ALL_B       | SEGMENT1                   | Lookup via PJC_PROJECT_ID       |
| 38| PROJECT_NAME                 | VARCHAR            |     | PJF_PROJECTS_ALL_TL      | NAME                       | Lookup via PROJECT_ID + LANG=US |
| 39| TASK_NUMBER                  | VARCHAR            |     | PJF_PROJ_ELEMENTS_B      | ELEMENT_NUMBER             | Lookup via PJC_PROJECT_ID+TASK  |
| 40| TASK_NAME                    | VARCHAR            |     | PJF_PROJ_ELEMENTS_TL     | NAME                       | Lookup via PROJ_ELEMENT_ID+LANG |
| 41| WIP_OPERATION_SEQ_NUM        | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | WIP_OPERATION_SEQ_NUM      | Direct                          |
| 42| WIP_REPETITIVE_SCHEDULE_ID   | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | WIP_REPETITIVE_SCHEDULE_ID | Direct                          |
| 43| WIP_RESOURCE_SEQ_NUM         | NUMBER             |     | PO_DISTRIBUTIONS_ALL     | WIP_RESOURCE_SEQ_NUM       | Direct                          |
| 44| PREVENT_ENCUMBRANCE_FLAG     | VARCHAR            |     | PO_DISTRIBUTIONS_ALL     | PREVENT_ENCUMBRANCE_FLAG   | Direct                          |
| 45| IS_DELETE                    | BOOLEAN            | HK  | —                        | —                          | Hard-coded 'N'::BOOLEAN         |
| 46| BIW_INS_DTTM                | TIMESTAMP_NTZ      | HK  | —                        | —                          | V_START_DTTM from batch control |
| 47| BIW_UPD_DTTM                | TIMESTAMP_NTZ      | HK  | —                        | —                          | V_START_DTTM from batch control |
| 48| BIW_BATCH_ID                | NUMBER(38,0)       | HK  | —                        | —                          | V_BIW_BATCH_ID from batch       |
| 49| BIW_MD5_KEY                 | BINARY             | HK  | —                        | —                          | MD5 of all non-PK/non-HK cols   |

## Enterprise Pattern Features Applied

| Feature                        | Status |
|--------------------------------|--------|
| Header block with run commands | Yes    |
| Batch control (5-parameter)    | Yes    |
| Jinja variables block          | Yes    |
| Config block (schema/alias)    | Yes    |
| Source ref with ODS_ prefix    | Yes    |
| Separate CTEs per source       | Yes    |
| _TL pre-joined inside CTE     | Yes    |
| Language filter (US)           | Yes    |
| PROJECT_NUMBER IS NOT NULL     | Yes    |
| LEFT OUTER JOIN pattern        | Yes    |
| Dual-column join (Elements)    | Yes    |
| MD5 PK (OBJECT_CONSTRUCT)     | Yes    |
| MD5 COL numbered keys          | Yes    |
| BIW_MD5_KEY ::BINARY           | Yes    |
| IS_DELETE = 'N' filter         | Yes    |
| Watermark incremental filter   | Yes    |
| Backfill support (is_backfill) | Yes    |
| Timestamps from V_START_DTTM   | Yes    |
| IS_DELETE last in MD5           | Yes    |

## Validation Summary

- **Total columns mapped**: 49 (44 business + 5 housekeeping)
- **Source tables**: 5 (1 main driver + 2 lookup + 2 translation)
- **Enterprise pattern match**: ~90%
- **Model file**: `ETL_MART_PROCUREMENT_PO_DISTRIBUTION_DIM.sql`
