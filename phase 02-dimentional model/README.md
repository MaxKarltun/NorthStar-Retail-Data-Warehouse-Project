# Phase 2 — Requirements and Kimball Bus Matrix

Phase 2 turns stakeholder needs into business requirements and measurable KPIs, declares the grain of each fact table, and identifies conformed dimensions for integrated reporting.

## Scope decisions

- **Sales:** current transaction process; one fact row per sales order line item.
- **Returns:** current transaction process; one fact row per returned order line item.
- **Inventory:** future periodic-snapshot process; one fact row per product per store per day when source data becomes available.

The inventory business process is shown in the proposed model but is not a current load requirement: inventory and reorder data are not available in the provided project source data.

## Deliverables

| File | Contents |
| --- | --- |
| [Business requirements and KPIs](Business_Requirements_and_KPIs.md) | Stakeholders, requirements, metrics, and scope |
| [Fact table design](Fact_Table_Design.md) | Fact types, measures, keys, and design rationale |
| [Grain statements](Grain%20Statements.md) | Declared row meaning for each fact |
| [Conformed dimensions](dimensions.md) | Dimension purpose, example attributes, and process use |
| [Bus matrix](Bus_Matrix.md) | Dimension-to-process assignments |
| [Bus matrix diagram](bus-matrix.svg) | Visual summary of conformed dimensions |
| [Star-schema diagram](star-schema.svg) | Proposed fact and dimension relationships |

The `.png` files named `bus-matrix-lab2-submission.png` and `star-schema-lab2-submission.png` are original submission screenshots. The SVG files are the corrected, readable design diagrams aligned with the resubmission.
