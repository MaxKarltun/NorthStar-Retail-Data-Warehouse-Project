<div align="center">

# NorthStar Retail Data Warehouse

### From operational data to trusted business insight

A dimensional data-warehouse project for NorthStar Retail, following the Kimball lifecycle from source analysis and requirements through analytical reporting.

[![SQL](https://img.shields.io/badge/SQL-Analytics-4479A1)](https://www.iso.org/standard/63555.html)
[![DuckDB](https://img.shields.io/badge/DuckDB-Source%20Analysis-FFF000?logo=duckdb&logoColor=black)](https://duckdb.org/)
[![Snowflake](https://img.shields.io/badge/Snowflake-Warehouse-29B5E8?logo=snowflake&logoColor=white)](https://www.snowflake.com/)
[![Kimball](https://img.shields.io/badge/Modeling-Kimball-0B6E69)](https://www.kimballgroup.com/)
[![Power BI](https://img.shields.io/badge/BI-Power%20BI-F2C811?logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)

</div>

## Project overview

This repository documents the design and development of a NorthStar Retail data warehouse. It starts with source-system analysis and stakeholder requirements, then defines dimensional models and supports warehouse implementation, data-quality validation, and business analysis.

The project is organized into phases. The Phase 2 requirements and Kimball bus matrix describe both current analytical processes and future scope. **Sales and Returns are in scope; Inventory is modeled as a future process because inventory and reorder source data are not available in the provided project data.**

## Project roadmap

| Phase | Focus | Status |
| --- | --- | --- |
| 1 | Environment setup, source analysis, and OLTP business questions | Complete |
| 2 | Business requirements, KPIs, declared grain, and Kimball bus matrix | Complete |
| 3 | Warehouse architecture and conceptual data dictionary | Complete |
| 4 | Star schema, ETL, SCD Type 2, and data quality | Complete |
| 5 | OLAP and analytical SQL portfolio | Planned |
| 6 | Physical design and optimization | Planned |
| 7 | Power BI semantic model | Planned |
| 8 | Executive dashboard and capstone | Planned |

Phase status reflects the roadmap documented in this repository; see each phase's files for its deliverables.

## Phase 1: Environment setup and OLTP source analysis

Phase 1 established the DuckDB source-analysis environment, smoke-tested the loaded NorthStar data, and used SQL to explore the operational system and answer initial business questions. The analysis examined revenue by product category and customer segment, and order volume by sales channel. It also considered why an OLTP system built for day-to-day transactions is not the ideal foundation for repeated, cross-business analytical reporting.

- [Phase 1 overview and validation evidence](phase01-source-analysis/README.md)
- [Business-question SQL portfolio](business-questions-sql/)
- [Smoke-test row-count evidence](phase01-source-analysis/validation/smoke-test-result%20count.png)
- [Revenue by product category](phase01-source-analysis/validation/Revenue%20by%20Product%20Category.png)
- [Orders processed by store/channel](phase01-source-analysis/validation/Orders%20Processed%20by%20Store_Channel.png)
- [Revenue by customer segment](phase01-source-analysis/validation/Revenue%20By%20Customer%20Support.png)

## Phase 2: Requirements and dimensional model

Phase 2 translates stakeholder questions into measurable requirements, defines the grain of each proposed fact table, and identifies dimensions shared across business processes.

- [Phase 2 overview](phase%2002-dimentional%20model/README.md)
- [Business requirements and KPI catalog](phase%2002-dimentional%20model/Business_Requirements_and_KPIs.md)
- [Fact table design and rationale](phase%2002-dimentional%20model/Fact_Table_Design.md)
- [Declared grain statements](phase%2002-dimentional%20model/Grain%20Statements.md)
- [Conformed dimensions](phase%2002-dimentional%20model/dimensions.md)
- [Kimball bus matrix](phase%2002-dimentional%20model/Bus_Matrix.md)
- [Bus matrix diagram](phase%2002-dimentional%20model/bus-matrix.svg)
- [Proposed star-schema diagram](phase%2002-dimentional%20model/star-schema.svg)

The design identifies Date, Product, and Store as shared dimensions for Sales, Returns, and future Inventory. Customer and Promotion are shared by Sales and Returns. Returns inherit the original sale's promotion where that relationship is available. Inventory metrics remain deferred until suitable source data is provided.

## Phase 3: Architecture and data dictionary

Phase 3 describes the proposed flow from the NorthStar OLTP source through staging and ETL to a dimensional warehouse and Power BI. It also documents conceptual fact and dimension fields, source mappings, and the Kimball design rationale.

- [Phase 3 overview and architecture diagram](phase03-architecture/README.md)
- [Conceptual data dictionary](phase03-architecture/data-dictionary.md)
- [Source-to-target mapping and implementation notes](phase03-architecture/source-to-target.md)
- [Architecture and design rationale](phase03-architecture/architecture.md)

The Phase 3 documents describe a **design**, not evidence that every pipeline, table, or dashboard has been implemented. `DimReturnReason` is introduced for returns, while sales channel remains an attribute of `DimStore`.

## Phase 4: Star schema, ETL, and data quality

Phase 4 implements the NorthStar Retail sales star schema in Snowflake. The Lab 4 resubmission reports five dimensions (`DIM_DATE`, `DIM_CUSTOMER`, `DIM_PRODUCT`, `DIM_STORE`, and `DIM_PROMOTION`) and `FACT_SALES` at one row per order line. The sales ETL resolves dimension surrogate keys, assigns unmatched promotions to a default member, and calculates extended sales, cost, and margin. Customer history is preserved with SCD Type 2, and the reported data-quality checks reconcile the loaded fact table to its source.

- [Phase 4 overview and star-schema diagram](phase04-star-schema-etl/README.md)
- [Implemented schema and grain](phase04-star-schema-etl/implementation.md)
- [ETL and SCD Type 2 process](phase04-star-schema-etl/etl-and-scd2.md)
- [Data-quality results](phase04-star-schema-etl/data-quality.md)
- [Snowflake sales star-schema diagram](phase04-star-schema-etl/star-schema.svg)

**Implementation scope:** Lab 4 documents the sales fact and its five dimensions. Returns is part of the earlier conceptual design, but a `FACT_RETURNS` load is not reported as implemented in Lab 4. Inventory remains future scope because inventory source data is unavailable.

## Repository map

```text
.
├── business-questions-sql/       # Source-system analysis queries
├── docs/                         # Project roadmap and overview assets
├── phase01-source-analysis/      # Source analysis and validation evidence
├── phase 02-dimentional model/   # Requirements, KPIs, grain, dimensions, bus matrix
├── phase03-architecture/         # Architecture and conceptual data dictionary
└── phase04-star-schema-etl/      # Implemented sales schema, ETL, SCD2, validation
```

## Technology and methods

- **Source analysis:** DuckDB and SQL
- **Warehouse implementation:** Snowflake
- **Proposed ETL:** Python
- **Dimensional modeling:** Kimball bus matrix, conformed dimensions, and declared grain
- **Planned reporting:** Power BI

## Author

Maximiliano Karltun Moreno

Master of Science in Data Engineering & Analytics
