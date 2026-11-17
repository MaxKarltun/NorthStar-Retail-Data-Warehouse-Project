# Source-to-Target Mapping Notes

These are conceptual mappings from Lab 3, not executable ETL specifications. Refer to the [data dictionary](data-dictionary.md) for individual fields and proposed types.

| Target | Source or derivation in Lab 3 | Implementation consideration |
| --- | --- | --- |
| `FactSales` | Order date, customer, product, store, quantity, and sales value | Resolve dimension keys and preserve one row per order line; confirm revenue derivation. |
| `FactReturns` | Return date, customer, product, store, reason, quantity, and amount | Resolve dimension keys and preserve one row per returned order line; confirm source structure and sale-line linkage. |
| `DimCustomer` | Customer attributes; generated surrogate and history fields | Define SCD Type 2 change detection, effective/expiration boundaries, and fact lookup rules. |
| `DimProduct` | `src_product` attributes and category | Lab 3 names `src_product.category`; the Phase 1 query joins `src_category`. Confirm the source and join. |
| `DimStore` | `src_store` attributes, including channel | Channel is a store attribute, not a separate dimension. |
| `DimDate` | Calendar date and derived month, quarter, and year | Confirm calendar generation and whether quarter uses a fiscal or calendar definition. |
| `DimPromotion` | `src_promotion` identifiers, name, discount, and dates | Verify source fields and define handling for sales without a promotion. |
| `DimReturnReason` | `src_return.reason_code` and `src_return.reason` | Confirm return-source fields and lookup behavior. |

## Open decisions before implementation

1. **Sales value:** Lab 3 calls the source “Sales Value” without an exact formula. Confirm how quantity, unit price, and discounts contribute to revenue.
2. **Promotion attribution:** Lab 2 calls for Promotion on Sales and Returns; Lab 3's fact-field lists omit those keys. Decide physical keys and how return rows inherit the promotion from the original sale line.
3. **Customer history:** Decide effective-date boundaries, current-flag representation, and whether fact lookups use the customer version effective on the transaction date.
4. **Returns lineage:** Verify the return-to-order-line relationship, dimensions available at return time, reason codes, and returned-amount definition.
5. **Dates and inventory:** Confirm the fiscal calendar and generate required date coverage. Inventory and reorder processing remains deferred until the relevant sources exist.

The presence of a conceptual mapping does not establish that a source field exists, that a load has run, or that a Power BI report has been deployed.
