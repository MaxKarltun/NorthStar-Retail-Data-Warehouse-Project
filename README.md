# NorthStar-Retail-Data-Warehouse-Project
Retail Data Warehouse End - to End.
NorthStar Retail Data Warehouse Project
Overview

This repository documents the design and implementation of a complete data warehouse for NorthStar Retail as part of my Master's studies in Data Engineering & Analytics.

The project follows the full data warehousing lifecycle, starting with the analysis of a normalized transactional database (OLTP), progressing through dimensional modeling and ETL development, and ending with an executive business intelligence dashboard in Power BI.

Project Roadmap
The warehouse is being developed incrementally through a series of structured lab assignments.


docs/NorthStar_Project_Roadmap.png
Project Goals
Analyze an OLTP source system
Identify analytical business requirements
Design a dimensional model
Build a star schema data warehouse
Develop ETL processes
Implement data quality controls
Create an OLAP analytical environment
Build executive dashboards in Power BI
Project Timeline


Phase 1: Environment Setup & OLTP Analysis ✅
Objectives
Configure DuckDB database environment
Load NorthStar Retail source data
Execute validation and smoke tests
Explore normalized source tables
Develop business questions
Write SQL against OLTP data
Evaluate OLTP vs OLAP tradeoffs
Deliverables
Environment setup screenshots
Smoke test validation
Business questions and SQL queries
OLTP analytical results
Reflection on OLTP limitations
Key Learning
This phase demonstrated that transactional systems are optimized for recording transactions rather than supporting business analytics. Analytical questions often required multiple joins and complex SQL, making reporting difficult and less scalable for business users.


Phase 2: Requirements & Kimball Bus Matrix ✅
Objectives
Identify stakeholders
Define KPIs
Create business requirements
Build Kimball Bus Matrix
Identify conformed dimensions
Deliverables
KPI Matrix
Stakeholder Analysis
Bus Matrix


Phase 3: Architecture Diagram & Data Dictionary
Objectives
Design warehouse architecture
Document source systems
Build data dictionary
Map source-to-target relationships


Phase 4: Star Schema, ETL & Data Quality
Objectives
Create dimensional model
Build fact tables
Build dimension tables
Develop ETL processes
Implement SCD Type 2
Validate data quality


Phase 5: OLAP & Analytical SQL Portfolio
Objectives
Analytical query development
KPI calculations
Aggregations
Drill-down analysis


Phase 6: Physical Design & Optimization
Objectives
Performance tuning
Storage optimization
Indexing strategy
Maintenance planning


Phase 7: Power BI Semantic Model
Objectives
Create semantic model
Build measures
Create DAX calculations
Define business metrics


Phase 8: Executive BI Dashboard & Capstone
Objectives
Executive KPI dashboard
Sales analytics
Inventory analytics
Customer analytics
Final presentation
Technology Stack
DuckDB
SQL
Kimball Methodology
Data Warehousing
ETL Development
Power BI
GitHub


Current Status
✅ Phase 1 Complete

✅ Phase 2 Complete

⬜ Phase 3 In Progress

⬜ Phase 4 Pending

⬜ Phase 5 Pending

⬜ Phase 6 Pending

⬜ Phase 7 Pending

⬜ Phase 8 Pending

Author
Maximiliano Moreno

Master of Science in Data Engineering & Analytics