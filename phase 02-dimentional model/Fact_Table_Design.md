# Fact Table Design

This design follows the Phase 2 business requirements and declared grains. Sales and Returns are current analytical processes. Inventory is a proposed future process; its source data is not available in the provided dataset.

## FactSales

**Fact type:** Transaction fact
**Declared grain:** One row per sales order line item.

**Measures**

- `sales_amount` — sales value at the order-line grain
- `quantity_sold` — units sold
- `discount_amount` — discount applied to the line
- `cost_amount` — cost associated with the sold line, when supplied by the source

Gross profit is derived as `sales_amount - cost_amount`; profit margin is gross profit divided by sales amount. Promotion revenue is calculated by aggregating sales lines associated with each promotion. Average order value is total sales amount divided by the distinct number of orders.

**Dimension foreign keys**

- Date
- Customer
- Product
- Store
- Promotion

## FactReturns

**Fact type:** Transaction fact
**Declared grain:** One row per returned order line item.

**Measures**

- `return_amount` — value of the returned line
- `return_quantity` — units returned

**Dimension foreign keys**

- Date
- Customer
- Product
- Store
- Promotion, inherited from the original sale line when the relationship is available

Returns are discrete events, so each returned order line is retained for analysis and auditability. Return rates should be calculated by separately aggregating return quantities and sales quantities at the same dimensional level, then joining the aggregates. Joining raw sales lines directly to raw return lines can multiply rows and inflate measures.

## FactInventory — future

**Fact type:** Periodic snapshot fact
**Declared grain:** One row per product per store per day.

**Measures**

- `quantity_on_hand` — inventory balance at the snapshot time
- `reorder_point` — replenishment threshold, if available in a future source

**Dimension foreign keys**

- Date
- Product
- Store

Inventory on hand, stockout, and low-inventory metrics can be derived from periodic balances and reorder thresholds. Inventory turnover also requires cost-of-goods-sold and an average inventory balance over a defined period; it should not be presented as a measure sourced from the inventory snapshot alone.

## Design rationale

The grain is stated before selecting measures and dimensions so each fact row has an unambiguous meaning. Sales and Returns use transaction facts because they capture individual business events. Inventory uses a periodic snapshot because a balance is observed repeatedly over time. Conformed dimensions let analysts compare processes consistently without joining fact tables at incompatible grains.
