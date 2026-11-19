-- Lab 5 Snowflake SQL portfolio. Run CREATE VIEW before its validation and use.
-- The view creation statement fails if VW_LAB5_MONTHLY_SALES already exists.

-- Sales baseline: one fact row is one order line, not one order.
SELECT
    MIN(d.full_date) AS first_sale_date,
    MAX(d.full_date) AS last_sale_date,
    COUNT(*) AS sales_line_count,
    COUNT(DISTINCT f.order_id) AS order_count,
    SUM(f.extended_sales) AS total_revenue,
    SUM(f.quantity) AS total_units,
    SUM(f.margin_amount) AS total_margin
FROM MMIS642.PUBLIC.FACT_SALES f
JOIN MMIS642.PUBLIC.DIM_DATE d
    ON f.date_key = d.date_key;

-- Time roll-up: months, quarters, years, and grand total.
SELECT
    d.year AS sales_year,
    d.quarter AS sales_quarter,
    d.month_no AS sales_month,
    CASE
        WHEN GROUPING(d.year) = 1 THEN 'Grand total'
        WHEN GROUPING(d.quarter) = 1 THEN 'Year total'
        WHEN GROUPING(d.month_no) = 1 THEN 'Quarter total'
        ELSE 'Month'
    END AS row_type,
    SUM(f.extended_sales) AS revenue,
    SUM(f.quantity) AS units,
    SUM(f.margin_amount) AS margin
FROM MMIS642.PUBLIC.FACT_SALES f
JOIN MMIS642.PUBLIC.DIM_DATE d
    ON f.date_key = d.date_key
GROUP BY ROLLUP(d.year, d.quarter, d.month_no)
ORDER BY d.year NULLS LAST, d.quarter NULLS LAST, d.month_no NULLS LAST;

-- Drill down from Q1 2023 into its months.
SELECT
    d.year AS sales_year,
    d.quarter AS sales_quarter,
    d.month_no AS sales_month,
    SUM(f.extended_sales) AS revenue,
    SUM(f.quantity) AS units,
    SUM(f.margin_amount) AS margin
FROM MMIS642.PUBLIC.FACT_SALES f
JOIN MMIS642.PUBLIC.DIM_DATE d
    ON f.date_key = d.date_key
WHERE d.year = 2023
  AND d.quarter = 1
GROUP BY d.year, d.quarter, d.month_no
ORDER BY d.month_no;

-- Slice 2024 physical-store sales by category and region.
SELECT
    p.category_name,
    s.region,
    s.channel,
    SUM(f.extended_sales) AS revenue,
    SUM(f.quantity) AS units,
    SUM(f.margin_amount) AS margin,
    ROUND(100.0 * SUM(f.margin_amount) / NULLIF(SUM(f.extended_sales), 0), 2) AS margin_pct
FROM MMIS642.PUBLIC.FACT_SALES f
JOIN MMIS642.PUBLIC.DIM_DATE d
    ON f.date_key = d.date_key
JOIN MMIS642.PUBLIC.DIM_PRODUCT p
    ON f.product_sk = p.product_sk
JOIN MMIS642.PUBLIC.DIM_STORE s
    ON f.store_sk = s.store_sk
WHERE d.year = 2024
  AND s.region IN ('Northeast', 'Southeast')
  AND s.channel = 'store'
GROUP BY p.category_name, s.region, s.channel
ORDER BY revenue DESC, p.category_name, s.region;

-- Monthly growth across years and year-to-date revenue within each year.
WITH monthly AS (
    SELECT
        d.year AS sales_year,
        d.month_no AS sales_month,
        SUM(f.extended_sales) AS revenue
    FROM MMIS642.PUBLIC.FACT_SALES f
    JOIN MMIS642.PUBLIC.DIM_DATE d
        ON f.date_key = d.date_key
    GROUP BY d.year, d.month_no
),
compared AS (
    SELECT
        *,
        LAG(revenue) OVER (ORDER BY sales_year, sales_month) AS previous_month_revenue
    FROM monthly
)
SELECT
    sales_year,
    sales_month,
    revenue,
    previous_month_revenue,
    ROUND(100.0 * (revenue - previous_month_revenue) / NULLIF(previous_month_revenue, 0), 2)
        AS mom_growth_pct,
    SUM(revenue) OVER (
        PARTITION BY sales_year
        ORDER BY sales_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS ytd_revenue
FROM compared
ORDER BY sales_year, sales_month;

-- Standard view: SQL definition only, not a materialized aggregate.
CREATE VIEW MMIS642.PUBLIC.VW_LAB5_MONTHLY_SALES AS
SELECT
    d.year AS sales_year,
    d.quarter AS sales_quarter,
    d.month_no AS sales_month,
    SUM(f.extended_sales) AS revenue,
    SUM(f.quantity) AS units,
    SUM(f.margin_amount) AS margin,
    COUNT(*) AS sales_line_count
FROM MMIS642.PUBLIC.FACT_SALES f
JOIN MMIS642.PUBLIC.DIM_DATE d
    ON f.date_key = d.date_key
GROUP BY d.year, d.quarter, d.month_no;

-- Reconcile monthly view totals with the sales baseline.
SELECT
    COUNT(*) AS month_count,
    SUM(sales_line_count) AS sales_line_count,
    SUM(revenue) AS total_revenue,
    SUM(units) AS total_units,
    SUM(margin) AS total_margin
FROM MMIS642.PUBLIC.VW_LAB5_MONTHLY_SALES;

-- Customer-level RFM across historical SCD Type 2 versions.
SELECT
    c.customer_id,
    MAX(d.full_date) AS last_purchase_date,
    DATEDIFF('day', MAX(d.full_date), DATE '2025-01-01') AS recency_days,
    COUNT(DISTINCT f.order_id) AS frequency_orders,
    SUM(f.extended_sales) AS monetary_value
FROM MMIS642.PUBLIC.FACT_SALES f
JOIN MMIS642.PUBLIC.DIM_DATE d
    ON f.date_key = d.date_key
JOIN MMIS642.PUBLIC.DIM_CUSTOMER c
    ON f.customer_sk = c.customer_sk
GROUP BY c.customer_id
ORDER BY monetary_value DESC, c.customer_id;

-- Relative quartile-based RFM segments.
WITH rfm AS (
    SELECT
        c.customer_id,
        DATEDIFF('day', MAX(d.full_date), DATE '2025-01-01') AS recency_days,
        COUNT(DISTINCT f.order_id) AS frequency_orders,
        SUM(f.extended_sales) AS monetary_value
    FROM MMIS642.PUBLIC.FACT_SALES f
    JOIN MMIS642.PUBLIC.DIM_DATE d
        ON f.date_key = d.date_key
    JOIN MMIS642.PUBLIC.DIM_CUSTOMER c
        ON f.customer_sk = c.customer_sk
    GROUP BY c.customer_id
),
scored AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY recency_days DESC, customer_id) AS r_score,
        NTILE(4) OVER (ORDER BY frequency_orders, customer_id) AS f_score,
        NTILE(4) OVER (ORDER BY monetary_value, customer_id) AS m_score
    FROM rfm
),
segmented AS (
    SELECT
        *,
        CASE
            WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3
                THEN 'Champions'
            WHEN r_score <= 2 AND (f_score >= 3 OR m_score >= 3)
                THEN 'At-risk valuable customers'
            WHEN r_score >= 3
                THEN 'Recent developing customers'
            ELSE 'Needs attention'
        END AS customer_segment
    FROM scored
)
SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(recency_days), 1) AS avg_recency_days,
    ROUND(AVG(frequency_orders), 1) AS avg_orders,
    ROUND(SUM(monetary_value), 2) AS segment_revenue,
    ROUND(100.0 * SUM(monetary_value) / NULLIF(SUM(SUM(monetary_value)) OVER (), 0), 2)
        AS revenue_share_pct
FROM segmented
GROUP BY customer_segment
ORDER BY segment_revenue DESC;

-- Use the reusable monthly view for reporting.
SELECT *
FROM MMIS642.PUBLIC.VW_LAB5_MONTHLY_SALES
ORDER BY sales_year, sales_month;
