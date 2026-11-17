# Conceptual Data Dictionary

This dictionary records the proposed Lab 3 fields and types. Names are conceptual and are not necessarily the column names or types of an implemented warehouse. The source mappings shown here follow the Lab 3 document; mappings marked for verification are not established physical source-to-target rules.

## FactSales

**Grain:** One row per sales order line item. `SalesKey` identifies a fact row; dimension keys link it to descriptive context.

| Column | Type | Meaning | Source / mapping |
| --- | --- | --- | --- |
| `SalesKey` | INT | Fact-row surrogate identifier | Generated |
| `DateKey` | INT | Date dimension key | Order date |
| `CustomerKey` | INT | Customer dimension key | Customer ID lookup |
| `ProductKey` | INT | Product dimension key | Product ID lookup |
| `StoreKey` | INT | Store dimension key | Store ID lookup |
| `QuantitySold` | INT | Units sold | Order quantity |
| `SalesAmount` | DECIMAL(12,2) | Sales revenue | Sales value; exact transformation to verify |

Lab 2 also calls for promotion attribution. The Lab 3 dictionary does not list a promotion key in `FactSales`; see [mapping notes](source-to-target.md).

## FactReturns

**Grain:** One row per returned order line item.

| Column | Type | Meaning | Source / mapping |
| --- | --- | --- | --- |
| `ReturnKey` | INT | Fact-row surrogate identifier | Generated |
| `ReturnDateKey` | INT | Return date dimension key | Return date |
| `CustomerKey` | INT | Customer dimension key | Customer ID lookup |
| `ProductKey` | INT | Product dimension key | Product ID lookup |
| `StoreKey` | INT | Store dimension key | Store ID lookup |
| `ReturnReasonKey` | INT | Return reason dimension key | Return reason lookup |
| `ReturnQuantity` | INT | Units returned | Return quantity |
| `ReturnAmount` | DECIMAL(12,2) | Returned value | Return amount |

Lab 2 requires returns to inherit promotion context from the original sale. The Lab 3 fact dictionary does not specify a promotion key or the source lineage needed for that lookup.

## DimCustomer

| Column | Type | Meaning | Source / mapping |
| --- | --- | --- | --- |
| `CustomerKey` | INT | Dimension surrogate key | Generated |
| `CustomerID` | VARCHAR(20) | Customer business identifier | Customer ID |
| `CustomerName` | VARCHAR(100) | Customer name | Customer name |
| `Segment` | VARCHAR(50) | Customer segment | Segment |
| `City` | VARCHAR(100) | Customer city | `src_customer.city` |
| `State` | VARCHAR(50) | Customer state | `src_customer.state` |
| `Region` | VARCHAR(50) | Customer region | `src_customer.region` |
| `Effective_Date` | DATE | SCD version start | Generated |
| `Expiration_Date` | DATE | SCD version end | Generated |
| `Is_Current` | CHAR(1) | Current-version flag | Generated |

## DimProduct

| Column | Type | Meaning | Source / mapping |
| --- | --- | --- | --- |
| `ProductKey` | INT | Dimension surrogate key | Generated |
| `ProductID` | VARCHAR(20) | Product business key | `src_product.product_id` |
| `ProductName` | VARCHAR(100) | Product name | `src_product.product_name` |
| `Category` | VARCHAR(50) | Product category | Lab 3 lists `src_product.category`; verify against source category relationship |
| `Brand` | VARCHAR(50) | Product brand | `src_product.brand` |

The repository's [Phase 1 category query](../business-questions-sql/question1.sql) joins `src_product` to `src_category` to obtain `category_name`. The Lab 3 category mapping and the observed query should be reconciled before implementing the load.

## DimStore

| Column | Type | Meaning | Source / mapping |
| --- | --- | --- | --- |
| `StoreKey` | INT | Dimension surrogate key | Generated |
| `StoreID` | VARCHAR(20) | Store business key | `src_store.store_id` |
| `StoreName` | VARCHAR(100) | Store name | `src_store.store_name` |
| `City` | VARCHAR(100) | Store city | `src_store.city` |
| `State` | VARCHAR(100) | Store state | `src_store.state` |
| `Channel` | VARCHAR(50) | Sales channel | `src_store.channel` |

## DimDate

| Column | Type | Meaning | Source / mapping |
| --- | --- | --- | --- |
| `DateKey` | INT | Date dimension key | Generated |
| `FullDate` | DATE | Calendar date | `calendar.date` |
| `Month` | VARCHAR(20) | Month name | `calendar.month` |
| `Quarter` | VARCHAR(10) | Fiscal quarter, as described in Lab 3 | `calendar.quarter`; fiscal definition to verify |
| `Year` | INT | Calendar year | `calendar.year` |

The calendar source and fiscal-quarter boundaries must be confirmed before treating these conceptual mappings as implementation rules.

## DimPromotion

| Column | Type | Meaning | Source / mapping |
| --- | --- | --- | --- |
| `PromotionKey` | INT | Dimension surrogate key | Generated |
| `PromotionID` | VARCHAR(20) | Promotion business key | `src_promotion.promotion_id` |
| `PromotionName` | VARCHAR(100) | Promotion name | `src_promotion.promo_name` |
| `DiscountPct` | DECIMAL(5,2) | Discount percentage | `src_promotion.discount_pct` |
| `StartDate` | DATE | Promotion start date | `src_promotion.start_date` |
| `EndDate` | DATE | Promotion end date | `src_promotion.end_date` |

## DimReturnReason

| Column | Type | Meaning | Source / mapping |
| --- | --- | --- | --- |
| `ReturnReasonKey` | INT | Dimension surrogate key | Generated |
| `ReturnReasonCode` | VARCHAR(20) | Return reason business key | `src_return.reason_code` |
| `ReturnReasonDescription` | VARCHAR(100) | Return reason description | `src_return.reason` |

Return source table and column availability, reason codes, and linkage to the original sale must be verified before implementation.
