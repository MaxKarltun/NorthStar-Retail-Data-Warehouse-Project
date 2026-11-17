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
| 4 | Star schema, ETL, SCD Type 2, and data quality | Planned |
| 5 | OLAP and analytical SQL portfolio | Planned |
| 6 | Physical design and optimization | Planned |
| 7 | Power BI semantic model | Planned |
| 8 | Executive dashboard and capstone | Planned |

Phase status reflects the roadmap documented in this repository; see each phase's files for its deliverables.

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

## Repository map

```text
.
├── business-questions-sql/       # Source-system analysis queries
├── docs/                         # Project roadmap and overview assets
├── phase01-source-analysis/      # Source analysis and validation evidence
├── phase 02-dimentional model/   # Requirements, KPIs, grain, dimensions, bus matrix
└── phase03-architecture/         # Architecture and conceptual data dictionary
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
