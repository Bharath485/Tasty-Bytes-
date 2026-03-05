# STTM → dbt Model Generation Report

## Session Summary
| Property | Value |
|----------|-------|
| Source Excel | PO_DISTRIBUTION_DIM.xlsx |
| Total Sheets Selected | 2 |
| Models Generated | 2 |
| Failed | 0 |
| Pattern Applied | ONSEMI Enterprise |
| Session Date | 2026-03-05 |

## Sheets Conversion Progress

| # | Sheet Name | Model Name | Status | Columns | CTEs | Complexity | Match % |
|---|------------|------------|--------|---------|------|------------|---------|
| 1 | MART.PO_DISTRIBUTION_DIM | ETL_MART_PROCUREMENT_PO_DISTRIBUTION_DIM | ✅ Generated | 49 | 5 | Medium | 90% |
| 2 | MART.PO_DISTRIBUTION_HIST_DIM | ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM | ✅ Generated | 53 | 1 | Low | 90% |

## Models Generated Detail

### Model 1: ETL_MART_PROCUREMENT_PO_DISTRIBUTION_DIM
| Property | Value |
|----------|-------|
| Sheet | MART.PO_DISTRIBUTION_DIM |
| Target Schema | ETL_MART_PROCUREMENT |
| Target Table | PO_DISTRIBUTION_DIM |
| Type | DIM TABLE (SCD1) |
| Primary Key | PO_DISTRIBUTION_KEY |
| Natural Key | PO_DISTRIBUTION_ID |
| Total Columns | 49 (44 business + 5 HK) |
| Source Tables | 5 |
| CTEs | 5 (PO_DISTRIBUTIONS_ALL, PJF_PROJECTS_ALL_B, PJF_PROJECTS_ALL_TL, PJF_PROJ_ELEMENTS_B, PJF_PROJ_ELEMENTS_TL) |
| Lines of Code | 267 |
| Complexity | Medium |
| Match % | 90% |

### Model 2: ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM
| Property | Value |
|----------|-------|
| Sheet | MART.PO_DISTRIBUTION_HIST_DIM |
| Target Schema | ETL_MART_PROCUREMENT |
| Target Table | PO_DISTRIBUTION_HIST_DIM |
| Type | SCD2 DIM TABLE (Snapshot) |
| Primary Key | PO_DISTRIBUTION_KEY, DBT_SCD_ID |
| Source | MART_PROCUREMENT.PO_DISTRIBUTION_DIM |
| Total Columns | 53 (44 business + 5 HK + 4 SCD2) |
| Source Tables | 1 |
| CTEs | 1 |
| Lines of Code | 175 |
| Complexity | Low |
| Match % | 90% |

## Source Tables & CTEs

### Model 1: PO_DISTRIBUTION_DIM
| # | Source Table | Schema | CTE Type | Join Key |
|---|--------------|--------|----------|----------|
| 1 | PO_DISTRIBUTIONS_ALL | ODS_ORACLE_CLOUD | Main Driver (incremental) | PO_DISTRIBUTION_ID |
| 2 | PJF_PROJECTS_ALL_B | ODS_ORACLE_CLOUD | Lookup | PROJECT_ID |
| 3 | PJF_PROJECTS_ALL_TL | ODS_ORACLE_CLOUD | Translation (_TL) | PROJECT_ID |
| 4 | PJF_PROJ_ELEMENTS_B | ODS_ORACLE_CLOUD | Lookup | PROJ_ELEMENT_ID |
| 5 | PJF_PROJ_ELEMENTS_TL | ODS_ORACLE_CLOUD | Translation (_TL) | PROJ_ELEMENT_ID |

### Model 2: PO_DISTRIBUTION_HIST_DIM
| # | Source Table | Schema | CTE Type | Join Key |
|---|--------------|--------|----------|----------|
| 1 | PO_DISTRIBUTION_DIM | MART_PROCUREMENT | Source DIM | PO_DISTRIBUTION_KEY |

## Validation Summary
| Check | Model 1 | Model 2 |
|-------|---------|---------|
| Header block | ✅ Pass | ✅ Pass |
| Batch control | ✅ Pass | ✅ Pass |
| ODS_ORACLE_CLOUD_ prefix | ✅ Pass | N/A |
| MD5 COL pattern | ✅ Pass | ✅ Pass |
| LEFT OUTER JOIN | ✅ Pass | N/A |
| Housekeeping columns | ✅ Pass | ✅ Pass |
| Incremental logic | ✅ Pass | ✅ Pass |
| V_START_DTTM usage | ✅ Pass | ✅ Pass |
| SCD2 columns | N/A | ✅ Pass |

## Generated At
2026-03-05 by Cortex Code (ONSEMI Enterprise Pattern)
