# Phase 1 — Environment Setup and OLTP Source Analysis

Phase 1 established the project’s local DuckDB source-analysis environment and used the NorthStar operational data to validate the loaded source and explore initial business questions with SQL.

## Objectives

- Configure DuckDB and load the provided NorthStar source data.
- Run a smoke test to verify that source data is available for analysis.
- Explore the normalized OLTP tables and their relationships.
- Use SQL to answer initial questions about product-category revenue, order volume by sales channel, and revenue by customer segment.
- Reflect on the difference between operational transaction processing and warehouse analytics.

## Deliverables

| Artifact | Description |
| --- | --- |
| [Business-question SQL portfolio](../business-questions-sql/) | SQL examples for category revenue, order volume, and customer-segment revenue |
| [Smoke-test row-count evidence](validation/smoke-test-result%20count.png) | Screenshot of the source-data smoke test |
| [Revenue by product category](validation/Revenue%20by%20Product%20Category.png) | Query-result evidence for category revenue |
| [Orders processed by store/channel](validation/Orders%20Processed%20by%20Store_Channel.png) | Query-result evidence for order volume by channel |
| [Revenue by customer segment](validation/Revenue%20By%20Customer%20Support.png) | Query-result evidence for customer-segment revenue |

## Business questions explored

1. Which product categories generated the highest sales revenue?
2. Which sales channels processed the highest number of orders?
3. Which customer segments generated the most revenue?

The queries use the operational source tables. They establish an initial analytical baseline, but the multi-table joins and repeated aggregations illustrate why a dimensional warehouse is useful for recurring business intelligence.

## OLTP and warehouse context

The source OLTP system supports day-to-day operations and transaction capture. Phase 1 used it for initial exploration, while the subsequent phases define a warehouse model that can organize measures and shared business dimensions for analytical reporting. The Phase 1 analysis is exploratory and should not be confused with the later warehouse implementation or its validated KPI definitions.
