# STTM → dbt Model Generation Report

## Session Summary
| Property | Value |
|----------|-------|
| Source Excel | LOGISTICS_DASHBOARD_PO_QUANTITY_RPT.xlsx |
| Total Sheets Selected | 1 |
| Models Generated | 1 |
| Failed | 0 |
| Pattern Applied | ONSEMI Enterprise |
| Session Date | 2026-03-05 |

## Sheets Conversion Progress

| # | Sheet Name | Model Name | Status | Columns | CTEs | Complexity | Match % |
|---|------------|------------|--------|---------|------|------------|---------|
| 1 | MART.LOGISTICS_DASHBOARD_PO_QUA | ETL_MART_LOGISTICS_LOGISTICS_DASHBOARD_PO_QUANTITY_RPT | ✅ Generated | 40 | 11 | Medium | 90% |

## Models Generated Detail

### Model 1: ETL_MART_LOGISTICS_LOGISTICS_DASHBOARD_PO_QUANTITY_RPT
| Property | Value |
|----------|-------|
| Sheet | MART.LOGISTICS_DASHBOARD_PO_QUA |
| Target Schema | ETL_MART_LOGISTICS |
| Target Table | LOGISTICS_DASHBOARD_PO_QUANTITY_RPT |
| Type | REPORT TABLE |
| Primary Key | LOGISTICS_DASHBOARD_PO_QUANTITY_KEY |
| Natural Keys | PO_HEADER_ID, PO_LINE_ID, LINE_LOCATION_ID |
| Total Columns | 40 (35 business + 5 HK) |
| Source Tables | 11 |
| CTEs | 11 |
| Lines of Code | 295 |
| Complexity | Medium |
| Match % | 90% |

## Source Tables & CTEs

| # | Source Table | Schema | CTE Type | Join Key |
|---|--------------|--------|----------|----------|
| 1 | PO_LINE_LOCATION_DIM | MART_PROCUREMENT | Main Driver (incremental) | LINE_LOCATION_ID |
| 2 | PO_HEADER_DIM | MART_PROCUREMENT | Lookup | PO_HEADER_ID |
| 3 | PO_LINE_DIM | MART_PROCUREMENT | Lookup | PO_LINE_ID |
| 4 | PO_RELEASE_FACT | MART_PROCUREMENT | Lookup | PO_HEADER_ID |
| 5 | SUPPLIER_DIM | MART_PROCUREMENT | Lookup | VENDOR_ID |
| 6 | SUPPLIER_SITE_DIM | MART_PROCUREMENT | Lookup | VENDOR_ID |
| 7 | PDH_ITEM_ORGANIZATION_DIM | MART_PDM | Lookup | INVENTORY_ITEM_ID |
| 8 | HR_LOCATIONS_ALL | ODS_HCM_SHARED | Lookup | LOCATION_ID |
| 9 | PERSON_DIM | MART_PROCUREMENT | Lookup | PERSON_ID |
| 10 | HR_ORGANIZATION_UNITS | ODS_HCM_SHARED | Lookup | ORGANIZATION_ID |
| 11 | PO_LINE_LOCATION_CURR_FACT | MART_PROCUREMENT | Lookup | LINE_LOCATION_ID |

## Column Mapping Summary

| # | Target Column | Source Table | Source Field | ETL Rule |
|---|---------------|--------------|--------------|----------|
| 1 | LOGISTICS_DASHBOARD_PO_QUANTITY_KEY | - | MD5(PO_HEADER_ID,PO_LINE_ID,LINE_LOCATION_ID) | PK Generation |
| 2 | PO_HEADER_ID | PO_HEADER_DIM | PO_HEADER_ID | Direct |
| 3 | PO_LINE_ID | PO_LINE_DIM | PO_LINE_ID | Direct |
| 4 | LINE_LOCATION_ID | PO_LINE_LOCATION_DIM | LINE_LOCATION_ID | Direct |
| 5 | PO_NUMBER | PO_HEADER_DIM | SEGMENT1,RELEASE_NUM | Concatenation |
| 6 | LINE_NUM | PO_LINE_DIM | LINE_NUM | Direct |
| 7 | PO_LINE_NUMBER | PO_LINE_DIM | LINE_NUM | Direct |
| 8 | SHIPMENT_NUMBER | PO_LINE_LOCATION_DIM | SHIPMENT_NUM | Direct |
| 9 | PO_NUM_LINE_SHIP | Multiple | SEGMENT1,LINE_NUM,SHIPMENT_NUM | Concatenation |
| 10 | STATUS | PO_LINE_LOCATION_DIM | SCHEDULE_STATUS | NVL Transform |
| 11 | SUPPLIER | SUPPLIER_DIM | SUPPLIER_NAME | Direct |
| 12 | SUPPLIER_SITE | SUPPLIER_SITE_DIM | SUPPLIER_SITE_CODE | Direct |
| 13 | ITEM_NUM | PDH_ITEM_ORGANIZATION_DIM | ITEM_NUMBER | Direct |
| 14 | ITEM_DESCRIPTION | PO_LINE_DIM | ITEM_DESCRIPTION | Direct |
| 15 | SUPPLIER_ITEM_NUM | PO_LINE_DIM | VENDOR_PRODUCT_NUM | Direct |
| 16 | DUE_DATE | PO_LINE_LOCATION_DIM | PROMISED_DATE,NEED_BY_DATE | NVL Transform |
| 17 | PROMISED_DATE | PO_LINE_LOCATION_DIM | PROMISED_DATE | Direct |
| 18 | LINE_CREATION_DATE | PO_LINE_LOCATION_DIM | CREATION_DATE | Direct |
| 19 | PO_APPROVED_DATE | PO_HEADER_DIM | APPROVED_DATE | Direct |
| 20 | PO_TYPE | PO_HEADER_DIM | ATTRIBUTE7 | Direct |
| 21 | CURRENCY_CODE | PO_HEADER_DIM | CURRENCY_CODE | Direct |
| 22 | UNIT_MEAS_LOOKUP_CODE | PO_LINE_DIM | UOM_CODE | Direct |
| 23 | SHIP_TO_LOCATION | HR_LOCATIONS_ALL | LOCATION_CODE | Direct |
| 24 | AUTHORIZATION_STATUS | Multiple | AUTHORIZATION_STATUS | DECODE Transform |
| 25 | MATCHING_TYPE | PO_LINE_LOCATION_DIM | RECEIPT_REQUIRED_FLAG,INSPECTION_REQUIRED_FLAG | DECODE Transform |
| 26 | PAST_DUE | PO_LINE_LOCATION_DIM | NEED_BY_DATE | CASE Transform |
| 27 | BUYER | PERSON_DIM | FULL_NAME | Direct |
| 28 | PLANNER_CODE | PDH_ITEM_ORGANIZATION_DIM | PLANNER_CODE | Direct |
| 29 | NAME | HR_ORGANIZATION_UNITS | NAME | Direct |
| 30 | QUANTITY_DUE | PO_LINE_LOCATION_CURR_FACT | QUANTITY,QUANTITY_RECEIVED | Calculation |
| 31 | QUANTITY_ORDERED | PO_LINE_LOCATION_CURR_FACT | QUANTITY | Direct |
| 32 | QUANTITY_RECEIVED | PO_LINE_LOCATION_CURR_FACT | QUANTITY_RECEIVED | Direct |
| 33 | QUANTITY_BILLED | PO_LINE_LOCATION_CURR_FACT | QUANTITY_BILLED | Direct |
| 34 | QUANTITY_CANCELLED | PO_LINE_LOCATION_CURR_FACT | QUANTITY_CANCELLED | Direct |
| 35 | SHIPMENT_AMOUNT | PO_LINE_LOCATION_CURR_FACT | PRICE_OVERRIDE,QUANTITY,QUANTITY_CANCELLED | Calculation |
| 36 | IS_DELETE | - | 'N' | Housekeeping |
| 37 | BIW_INS_DTTM | - | V_START_DTTM | Housekeeping |
| 38 | BIW_UPD_DTTM | - | V_START_DTTM | Housekeeping |
| 39 | BIW_BATCH_ID | - | V_BIW_BATCH_ID | Housekeeping |
| 40 | BIW_MD5_KEY | - | MD5(ALL COLUMNS) | Housekeeping |

## Validation Summary
| Check | Status |
|-------|--------|
| Header block | ✅ Pass |
| Batch control | ✅ Pass |
| MART ref() pattern | ✅ Pass |
| MD5 COL pattern | ✅ Pass |
| LEFT OUTER JOIN | ✅ Pass |
| Housekeeping columns | ✅ Pass |
| Incremental logic | ✅ Pass |
| V_START_DTTM usage | ✅ Pass |

## Generated At
2026-03-05 by Cortex Code (ONSEMI Enterprise Pattern)
