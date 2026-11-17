# Declared Grain Statements

| Fact table | Status | One row represents |
| --- | --- | --- |
| `FactSales` | In scope | One sales order line item |
| `FactReturns` | In scope | One returned order line item |
| `FactInventory` | Future | One product per store per day |

The grain defines the real-world event or observation represented by one fact row. Declare it before selecting measures or dimensions. Inventory is included as a future design target only; the provided project source data does not currently support loading inventory or reorder facts.
