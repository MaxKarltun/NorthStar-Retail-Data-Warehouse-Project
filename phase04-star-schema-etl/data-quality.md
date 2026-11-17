# Data-Quality Results

The Lab 4 submission reports the following checks on `FACT_SALES`.

| Check | Purpose | Reported result | Status |
| --- | --- | --- | --- |
| Null foreign keys | Ensure fact rows have required dimension keys | 0 rows returned | PASS |
| Referential integrity | Find fact rows with orphaned dimension keys | 0 orphan records | PASS |
| Duplicate sales | Check for duplicated sales transactions | 0 rows returned | PASS |
| Source-to-fact row count | Confirm source order lines were loaded | `SRC_ORDER_ITEM`: 119,352; `FACT_SALES`: 119,352 | PASS |

Additional reported dimension load results:

| Table | Reported row count |
| --- | ---: |
| `DIM_DATE` | 1,096 |
| `DIM_CUSTOMER` after SCD Type 2 | 3,309 |

## Interpretation

The fact and source row counts reconcile exactly, and the reported foreign-key and duplicate checks returned no issues. These results support the claim that the documented load retained all source order lines and linked them to dimensions. The checks are the results reported in the Lab 4 submission; this repository does not include execution logs or an independent Snowflake connection to rerun them.

## Suggested repeatable validation query patterns

These patterns illustrate the checks described above. Adapt the dimension key names if the physical schema differs.

```sql
-- Required foreign keys are not null.
SELECT COUNT(*) AS rows_with_null_keys
FROM FACT_SALES
WHERE date_key IS NULL
   OR customer_sk IS NULL
   OR product_sk IS NULL
   OR store_sk IS NULL
   OR promotion_sk IS NULL;
```

```sql
-- Compare source order lines with loaded fact rows.
SELECT
    (SELECT COUNT(*) FROM SRC_ORDER_ITEM) AS source_line_count,
    (SELECT COUNT(*) FROM FACT_SALES) AS fact_line_count;
```

Referential-integrity checks should left join each non-null fact surrogate key to its corresponding dimension and count missing matches. Duplicate checks should use the source's actual order-line business key; `ORDER_ID` alone is not unique at the declared order-line grain.
