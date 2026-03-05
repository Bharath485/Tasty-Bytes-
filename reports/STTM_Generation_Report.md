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
