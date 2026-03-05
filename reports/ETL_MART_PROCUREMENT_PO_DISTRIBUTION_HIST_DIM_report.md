# STTM → dbt Model Generation Report

## Model Information
| Property | Value |
|----------|-------|
| Model Name | ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM.sql |
| Source Excel | PO_DISTRIBUTION_DIM.xlsx |
| Sheet Processed | MART.PO_DISTRIBUTION_HIST_DIM |
| Generated Date | 2026-03-05 |
| Pattern Applied | ONSEMI Enterprise (SCD2 Snapshot) |
| **Match Percentage** | **90%** |

## Target Configuration
| Property | Value |
|----------|-------|
| Database | EDWPRD |
| Schema | ETL_MART_PROCUREMENT |
| Table | PO_DISTRIBUTION_HIST_DIM |
| Table Type | SCD2 DIM TABLE (Snapshot) |
| Primary Key | PO_DISTRIBUTION_KEY |
| Natural Key | PO_DISTRIBUTION_ID |
| Load Strategy | MERGE (dbt Snapshot) |
| SCD Strategy | check (all columns) |

## Column Statistics
| Metric | Count |
|--------|-------|
| Total Columns | 53 |
| Business Columns | 44 |
| Housekeeping Columns | 5 |
| SCD2 Columns | 4 (DBT_SCD_ID, DBT_UPDATED_AT, DBT_VALID_FROM, DBT_VALID_TO) |

## Source Table
| # | Source Table | Ref Name | Type | Filter |
|---|--------------|----------|------|--------|
| 1 | PO_DISTRIBUTION_DIM | ETL_MART_PROCUREMENT_PO_DISTRIBUTION_DIM | MART DIM | IS_DELETE = FALSE |

## SCD2 Configuration
| Property | Value |
|----------|-------|
| Strategy | check |
| Check Columns | all |
| Invalidate Hard Deletes | True |
| Unique Key | PO_DISTRIBUTION_KEY |

## Column Mappings
| # | Target Column | Source Table | Source Field | Notes |
|---|---------------|--------------|--------------|-------|
| 1 | PO_DISTRIBUTION_KEY | PO_DISTRIBUTION_DIM | PO_DISTRIBUTION_KEY | PK |
| 2 | PO_DISTRIBUTION_ID | PO_DISTRIBUTION_DIM | PO_DISTRIBUTION_ID | NK |
| 3 | DISTRIBUTION_NUM | PO_DISTRIBUTION_DIM | DISTRIBUTION_NUM | Direct |
| 4 | PO_HEADER_ID | PO_DISTRIBUTION_DIM | PO_HEADER_ID | Direct |
| 5-44 | ... | PO_DISTRIBUTION_DIM | ... | Direct Pass-through |
| 45 | IS_DELETE | PO_DISTRIBUTION_DIM | IS_DELETE | HK |
| 46 | BIW_INS_DTTM | PO_DISTRIBUTION_DIM | BIW_INS_DTTM | HK |
| 47 | BIW_UPD_DTTM | PO_DISTRIBUTION_DIM | BIW_UPD_DTTM | HK |
| 48 | BIW_BATCH_ID | PO_DISTRIBUTION_DIM | BIW_BATCH_ID | HK |
| 49 | BIW_MD5_KEY | PO_DISTRIBUTION_DIM | BIW_MD5_KEY | HK |
| 50 | DBT_SCD_ID | dbt Snapshot | Auto-generated | SCD2 |
| 51 | DBT_UPDATED_AT | dbt Snapshot | Auto-generated | SCD2 |
| 52 | DBT_VALID_FROM | dbt Snapshot | Auto-generated | SCD2 |
| 53 | DBT_VALID_TO | dbt Snapshot | Auto-generated | SCD2 |

## ONSEMI Validation Checklist
| # | Check | Status |
|---|-------|--------|
| 1 | Header block with version history | ✅ |
| 2 | v_pk_list = ['PO_DISTRIBUTION_KEY'] | ✅ |
| 3 | v_dbt_job_name = 'DBT_ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM' | ✅ |
| 4 | edw_batch_control with 5 parameters | ✅ |
| 5 | Snapshot config with target_schema | ✅ |
| 6 | strategy = 'check' | ✅ |
| 7 | check_cols = 'all' | ✅ |
| 8 | invalidate_hard_deletes = True | ✅ |
| 9 | Source ref to MART DIM table | ✅ |
| 10 | IS_DELETE = FALSE filter | ✅ |

## Files Generated
| File | Path | Status |
|------|------|--------|
| Model SQL | models/cortex_generated/ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM.sql | ✅ Created (159 lines) |
| Report | reports/ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM_report.md | ✅ Created |

## Dependency Chain
```
ODS_ORACLE_CLOUD_PO_DISTRIBUTIONS_ALL
         ↓
ETL_MART_PROCUREMENT_PO_DISTRIBUTION_DIM (SCD1)
         ↓
ETL_MART_PROCUREMENT_PO_DISTRIBUTION_HIST_DIM (SCD2 Snapshot)
```

## Generated At
2026-03-05 (Cortex Code - ONSEMI Enterprise Pattern - SCD2 Snapshot)
