# STTM → dbt Model Generation Report

## Session Summary
| Property | Value |
|----------|-------|
| Source Excel(s) | PO_DISTRIBUTION_DIM.xlsx, LOGISTICS_DASHBOARD_PO_QUANTITY_RPT.xlsx |
| Total Sheets Selected | 6 |
| Models Generated | 6 |
| Failed | 0 |
| Pattern Applied | ONSEMI Enterprise |
| Session Date | 2026-03-06 |

## Sheets Conversion Progress

| # | Sheet Name | Model Name | Status | Columns | CTEs | Type | Match % |
|---|------------|------------|--------|---------|------|------|---------|
| 1 | MART.PO_DISTRIBUTION_DIM | ETL_MART_PROCUREMENT_PO_DISTRIBUTION_DIM | Generated | 49 | 5 | DIM (SCD1) | 90% |
| 2 | MART.PO_DISTRIBUTION_HIST_DIM | ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM | Generated | 53 | 1 | SCD2 MERGE | 90% |
| 3 | ANA.PO_DISTRIBUTION_DIM | ANA_PROCUREMENT_PO_DISTRIBUTION_DIM | Generated | 48 | 0 | VIEW Passthrough | 95% |
| 4 | ANA.PO_DISTRIBUTION__HIST_DIM | ANA_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM | Generated | 52 | 0 | VIEW Passthrough | 95% |
| 5 | MART.LOGISTICS_DASHBOARD_PO_QUA | ETL_MART_LOGISTICS_LOGISTICS_DASHBOARD_PO_QUANTITY_RPT | Generated | 40 | 11 | RPT (SCD1) | 90% |
| 6 | ANA.LOGISTICS_DASHBOARD_PO_QUAN | ANA_LOGISTICS_LOGISTICS_DASHBOARD_PO_QUANTITY_RPT | Generated | 39 | 0 | VIEW Passthrough | 95% |

## Data Lineage

```
ODS_ORACLE_CLOUD
  PO_DISTRIBUTIONS_ALL ──┐
  PJF_PROJECTS_ALL_B ────┤
  PJF_PROJECTS_ALL_TL ───┤
  PJF_PROJ_ELEMENTS_B ───┤
  PJF_PROJ_ELEMENTS_TL ──┘
         │
         ▼
  MART_PROCUREMENT.PO_DISTRIBUTION_DIM (ETL - SCD1)
         │
         ├──► MART_PROCUREMENT.PO_DISTRIBUTION_HIST_DIM (ETL - SCD2 MERGE)
         │         │
         │         └──► ANA_PROCUREMENT.PO_DISTRIBUTION_HIST_DIM (VIEW)
         │
         └──► ANA_PROCUREMENT.PO_DISTRIBUTION_DIM (VIEW)


MART_PROCUREMENT (multiple tables)
  PO_LINE_LOCATION_DIM ──┐ (driver)
  PO_HEADER_DIM ─────────┤
  PO_LINE_DIM ───────────┤
  PO_RELEASE_FACT ───────┤
  SUPPLIER_DIM ──────────┤
  SUPPLIER_SITE_DIM ─────┤
  PO_LINE_LOCATION_CURR_FACT ─┤
  PERSON_DIM ────────────┘
MART_PDM
  PDH_ITEM_ORGANIZATION_DIM ──┤
ODS_HCM_SHARED
  HR_LOCATIONS_ALL ───────────┤
  HR_ORGANIZATION_UNITS ──────┘
         │
         ▼
  ETL_MART_LOGISTICS.LOGISTICS_DASHBOARD_PO_QUANTITY_RPT (ETL - TABLE)
         │
         └──► ANA_LOGISTICS.LOGISTICS_DASHBOARD_PO_QUANTITY_RPT (VIEW)
```

## Models Generated Detail

### Model 1: ETL_MART_PROCUREMENT_PO_DISTRIBUTION_DIM
| Property | Value |
|----------|-------|
| Target | ETL_MART_PROCUREMENT.PO_DISTRIBUTION_DIM |
| Type | DIM TABLE (SCD1) |
| Materialized | table |
| Source | ODS_ORACLE_CLOUD (5 tables) |
| Columns | 49 (44 business + 5 HK) |

### Model 2: ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM
| Property | Value |
|----------|-------|
| Target | ETL_MART_PROCUREMENT.PO_DISTRIBUTION_HIST_DIM |
| Type | SCD2 DIM TABLE |
| Materialized | incremental (MERGE) |
| Source | MART_PROCUREMENT.PO_DISTRIBUTION_DIM |
| Columns | 53 (44 business + 5 HK + 4 SCD2) |

### Model 3: ANA_PROCUREMENT_PO_DISTRIBUTION_DIM
| Property | Value |
|----------|-------|
| Target | ANA_PROCUREMENT.PO_DISTRIBUTION_DIM |
| Type | VIEW Passthrough |
| Materialized | view |
| Source | MART_PROCUREMENT.PO_DISTRIBUTION_DIM |
| Columns | 48 |

### Model 4: ANA_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM
| Property | Value |
|----------|-------|
| Target | ANA_PROCUREMENT.PO_DISTRIBUTION_HIST_DIM |
| Type | VIEW Passthrough |
| Materialized | view |
| Source | MART_PROCUREMENT.PO_DISTRIBUTION_HIST_DIM |
| Columns | 52 (48 business + 4 SCD2) |

### Model 5: ETL_MART_LOGISTICS_LOGISTICS_DASHBOARD_PO_QUANTITY_RPT
| Property | Value |
|----------|-------|
| Target | ETL_MART_LOGISTICS.LOGISTICS_DASHBOARD_PO_QUANTITY_RPT |
| Type | RPT TABLE (SCD1) |
| Materialized | table |
| Source | MART_PROCUREMENT (8 tables), MART_PDM (1), ODS_HCM_SHARED (2) |
| Columns | 40 (35 business + 5 HK) |
| Driver CTE | PO_LINE_LOCATION_DIM |
| ETL Rules | 8 complex transformations (DECODE, CASE, NVL, MD5) |

### Model 6: ANA_LOGISTICS_LOGISTICS_DASHBOARD_PO_QUANTITY_RPT
| Property | Value |
|----------|-------|
| Target | ANA_LOGISTICS.LOGISTICS_DASHBOARD_PO_QUANTITY_RPT |
| Type | VIEW Passthrough |
| Materialized | view |
| Source | MART_LOGISTICS.LOGISTICS_DASHBOARD_PO_QUANTITY_RPT |
| Columns | 39 (35 business + 4 HK) |

## Validation Summary
| Check | Model 1 | Model 2 | Model 3 | Model 4 | Model 5 | Model 6 |
|-------|---------|---------|---------|---------|---------|---------|
| Header block | Pass | Pass | Pass | Pass | Pass | Pass |
| Batch control | Pass | Pass | N/A | N/A | Pass | N/A |
| MD5 COL pattern | Pass | Pass | N/A | N/A | Pass | N/A |
| LEFT OUTER JOIN | Pass | N/A | N/A | N/A | Pass | N/A |
| MERGE strategy | N/A | Pass | N/A | N/A | N/A | N/A |
| VIEW config | N/A | N/A | Pass | Pass | N/A | Pass |
| V_START_DTTM usage | Pass | Pass | N/A | N/A | Pass | N/A |
| ETL rules applied | Pass | Pass | N/A | N/A | Pass | N/A |

## Generated At
2026-03-06 by Cortex Code (ONSEMI Enterprise Pattern)
