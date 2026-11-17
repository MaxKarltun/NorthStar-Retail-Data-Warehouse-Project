# ETL and SCD Type 2

## Load sequence

The Lab 4 process creates the target star-schema tables, loads the dimensions, and then loads `FACT_SALES` using dimensional lookups. The reported dimension load order is before the fact load. The sales load joins source orders and order items to date, current customer, product, store, and promotion dimensions.

## Sales fact load

The following is the fact-load SQL included in the Lab 4 submission. Run it in the Snowflake database and schema where the source and target tables exist.

```sql
INSERT INTO FACT_SALES
(
    sales_sk,
    date_key,
    customer_sk,
    product_sk,
    store_sk,
    promotion_sk,
    order_id,
    quantity,
    unit_price,
    extended_sales,
    extended_cost,
    margin_amount
)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY o.order_id, oi.line_no
    ) AS sales_sk,
    d.date_key,
    dc.customer_sk,
    dp.product_sk,
    ds.store_sk,
    COALESCE(pr.promotion_sk, 0) AS promotion_sk,
    o.order_id,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS extended_sales,
    oi.quantity * dp.unit_cost AS extended_cost,
    (oi.quantity * oi.unit_price)
      - (oi.quantity * dp.unit_cost) AS margin_amount
FROM SRC_ORDERS o
JOIN SRC_ORDER_ITEM oi
    ON o.order_id = oi.order_id
JOIN DIM_DATE d
    ON TO_NUMBER(
           TO_CHAR(
               CAST(o.order_ts AS DATE),
               'YYYYMMDD'
           )
       ) = d.date_key
JOIN DIM_CUSTOMER dc
    ON o.customer_id = dc.customer_id
   AND dc.is_current = TRUE
JOIN DIM_PRODUCT dp
    ON oi.product_id = dp.product_id
JOIN DIM_STORE ds
    ON o.store_id = ds.store_id
LEFT JOIN DIM_PROMOTION pr
    ON oi.promotion_id = pr.promotion_id;
```

The `LEFT JOIN` preserves sales that lack a promotion match. `COALESCE` assigns those lines to the default promotion surrogate key (`0`), which the Lab 4 submission reports was inserted as the "No Promotion" dimension member.

## Customer SCD Type 2

When a tracked customer attribute changes (city, state, region, or segment), the existing current row is expired on the day before the change and marked not current. A new customer version is inserted with a new surrogate key, the change date as its effective date, and an open-ended expiration date. This preserves historical attributes rather than overwriting them.

### Expire current versions

```sql
UPDATE DIM_CUSTOMER d
SET
    expiration_date = u.change_date - 1,
    is_current = FALSE
FROM SRC_CUSTOMER_UPDATES u
WHERE d.customer_id = u.customer_id
  AND d.is_current = TRUE
  AND (
       u.city    <> d.city
    OR u.state   <> d.state
    OR u.region  <> d.region
    OR u.segment <> d.segment
  );
```

### Insert updated versions

```sql
INSERT INTO DIM_CUSTOMER
(
    customer_sk,
    customer_id,
    full_name,
    city,
    state,
    region,
    segment,
    effective_date,
    expiration_date,
    is_current
)
SELECT
    (SELECT MAX(customer_sk) FROM DIM_CUSTOMER)
      + ROW_NUMBER() OVER (ORDER BY u.customer_id),
    u.customer_id,
    u.first_name || ' ' || u.last_name,
    u.city,
    u.state,
    u.region,
    u.segment,
    u.change_date,
    DATE '9999-12-31',
    TRUE
FROM SRC_CUSTOMER_UPDATES u
JOIN DIM_CUSTOMER d
    ON u.customer_id = d.customer_id
WHERE (
       u.city    <> d.city
    OR u.state   <> d.state
    OR u.region  <> d.region
    OR u.segment <> d.segment
)
AND d.is_current = FALSE;
```

The Lab 4 example demonstrates customer 1913 with an expired version and a new current version. The submission reports 3,309 total customer dimension rows after SCD Type 2 processing. For production reloads, verify that the update feed is applied once per change and that each business customer has exactly one current row.

**Implementation caution:** The documented insert joins the update feed to all dimension rows for a customer and selects noncurrent rows. If a customer already has multiple expired versions, one update could match more than one historical row and insert duplicate new versions. Before reusing this pattern for repeated updates, reduce the update feed to one applicable change per customer, join only to the version being expired, and test that each customer has exactly one current row. The `MAX(customer_sk) + ROW_NUMBER()` key assignment also requires protection from concurrent loads and should be replaced with a controlled key-generation strategy for production.
