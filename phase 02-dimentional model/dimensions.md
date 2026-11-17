# Conformed Dimensions

The bus matrix defines which dimensions are used by each business process. Shared dimensions provide consistent terms and filters across fact tables.

| Dimension | Example descriptive attributes | Processes using it |
| --- | --- | --- |
| `DimDate` | Full date, day, month, quarter, year | Sales, Returns, Future Inventory |
| `DimCustomer` | Customer identifier, name, city, state, region, segment | Sales, Returns |
| `DimProduct` | Product identifier, product name, category, department, brand | Sales, Returns, Future Inventory |
| `DimStore` | Store identifier, store name, city, state, region, channel | Sales, Returns, Future Inventory |
| `DimPromotion` | Promotion identifier, promotion name, discount percentage | Sales, Returns |

## Conformance and scope notes

- Date, Product, and Store are conformed across Sales, Returns, and the proposed future Inventory process.
- Customer is shared by Sales and Returns so purchase and return behavior can be analyzed consistently.
- Promotion is shared by Sales and Returns. A return can inherit the promotion from its original sale line when that lineage is available.
- Inventory is future scope because inventory and reorder source data are not available in the provided data.

Attributes are conceptual examples for Phase 2. Final columns and history handling are determined during physical warehouse design.
