# Implemented Schema and Fact Grain

The Lab 4 target warehouse was created in Snowflake with five dimensions and one fact table.

## Tables

| Table | Role | Key and important attributes |
| --- | --- | --- |
| `DIM_DATE` | Date dimension | `DATE_KEY`, `FULL_DATE`, `DAY_OF_WEEK`, `MONTH_NO`, `MONTH_NAME`, `QUARTER`, `YEAR`, `IS_WEEKEND` |
| `DIM_CUSTOMER` | Customer dimension with SCD Type 2 history | `CUSTOMER_SK`, `CUSTOMER_ID`, customer attributes, `EFFECTIVE_DATE`, `EXPIRATION_DATE`, `IS_CURRENT` |
| `DIM_PRODUCT` | Product dimension | `PRODUCT_SK`, `PRODUCT_ID`, product name, category, department, brand, unit cost |
| `DIM_STORE` | Store dimension | `STORE_SK`, `STORE_ID`, store name, city, state, region, channel |
| `DIM_PROMOTION` | Promotion dimension | `PROMOTION_SK`, `PROMOTION_ID`, promotion name, discount percentage; default no-promotion member |
| `FACT_SALES` | Sales transaction fact | `SALES_SK`, dimension foreign keys, `ORDER_ID`, quantity, unit price, extended sales, extended cost, margin amount |

The Lab 4 fact-load SQL uses the uppercase Snowflake columns shown above. The conceptual Phase 2 and Phase 3 documents use logical names such as `FactSales`; the Lab 4 physical names use uppercase with `_SK` surrogate-key suffixes.

## Declared grain

One `FACT_SALES` row represents one sales order line item. `ORDER_ID` can repeat when an order contains multiple items; measures such as extended sales, cost, and margin are calculated at the order-line grain.

## Measures

- `EXTENDED_SALES = QUANTITY * UNIT_PRICE`
- `EXTENDED_COST = QUANTITY * DIM_PRODUCT.UNIT_COST`
- `MARGIN_AMOUNT = EXTENDED_SALES - EXTENDED_COST`

The fact table stores the dimensional surrogate keys used for joins. `PROMOTION_SK = 0` is used for sales lines with no matching promotion, corresponding to the default no-promotion record described in Lab 4.

## Design note

The Lab 4 document lists `FACT_SALES` as the implemented fact. Although Returns appears in the earlier conceptual design, this phase does not claim that a returns fact has been physically created or loaded. Inventory is not implemented.
