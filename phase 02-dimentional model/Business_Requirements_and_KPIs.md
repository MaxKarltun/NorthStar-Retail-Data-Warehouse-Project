# Business Requirements and KPI Catalog

## Purpose and scope

NorthStar Retail has sales, customer, product, store, promotion, and return data across operational sources without a centralized analytical model. The warehouse is intended to provide a consistent foundation for management reporting and Power BI analysis.

Sales and Returns are current analytical processes. Inventory and reorder reporting are future scope because the inventory source data is not available in the provided project dataset.

## Stakeholders

| Stakeholder | Information needs |
| --- | --- |
| CEO | Revenue growth, profitability, and enterprise performance |
| Director of Sales | Sales by store and product, demand trends, and top categories |
| Marketing Director | Promotion performance, customer behavior, and repeat purchasing |
| Operations Director | Product returns, return rates, and store performance |
| Operations Director — future | Inventory on hand, turnover, and stockouts when inventory data is available |

## Numbered business requirements

| # | Requirement | Primary stakeholder |
| --- | --- | --- |
| 1 | Report revenue by month, quarter, year, store, and product category. | CEO / Sales |
| 2 | Calculate units sold by product, category, and store. | Director of Sales |
| 3 | Compare promotional and non-promotional sales performance. | Marketing Director |
| 4 | Calculate gross profit and profit margin by product and category. | Executive Leadership |
| 5 | Report customer purchase history by month and year. | Operations Director |
| 6 | Identify top-selling products and product categories. | Director of Sales |
| 7 | Report repeat-purchase customers by month and year. | Marketing Director |
| 8 | Calculate return rates by product, store, and customer. | Operations Director |
| 9 | Report returned units and returned revenue. | Operations Director |
| 10 | Defer inventory reporting until inventory source data is available. | Operations Director |
| 11 | Defer reorder-threshold reporting until inventory source data is available. | Operations Director |
| 12 | Report sales, returns, and promotion performance through monthly and quarterly summaries. | All stakeholders |

## KPI catalog

| KPI | Example calculation | Stakeholder |
| --- | --- | --- |
| Revenue | `SUM(sales_amount)` | CEO |
| Gross profit | `SUM(sales_amount - cost_amount)` | CEO |
| Profit margin % | `100 * gross_profit / NULLIF(revenue, 0)` | CEO |
| Units sold | `SUM(quantity_sold)` | Director of Sales |
| Average order value | `revenue / COUNT(DISTINCT order_id)` | Director of Sales |
| Promotion revenue | Revenue grouped by promotion; compare with non-promotional sales | Marketing Director |
| Repeat-purchase customers | Count customers with more than one distinct order in the period | Marketing Director |
| Returned units | `SUM(return_quantity)` | Operations Director |
| Returned revenue | `SUM(return_amount)` | Operations Director |
| Return rate % | Return quantity divided by sales quantity at the same dimensional grain | Operations Director |
| Inventory on hand — future | `SUM(quantity_on_hand)` at a defined snapshot date | Operations Director |
| Inventory turnover — future | Period COGS divided by average inventory value for that period | Operations Director |
| Stockout rate — future | Stockout product-store observations divided by eligible observations | Operations Director |

For return rate, aggregate sales and returns independently at the target reporting dimensions before joining the results. This avoids multiplying fact rows when a product has multiple sales lines and return lines.

## References

Kimball, R., & Ross, M. (2013). *The data warehouse toolkit: The definitive guide to dimensional modeling* (3rd ed.). Wiley.

NorthStar Retail. (2026). *NorthStar data_dictionary.md* [Course-provided source document].

NorthStar Retail. (2026). *Stakeholder personas handout* [Course-provided source document].
