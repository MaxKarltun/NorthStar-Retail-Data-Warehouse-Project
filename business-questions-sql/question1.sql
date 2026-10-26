
/*Business Question 1 

Which product categories generated the highest sales revenue? 

Key Results 

Apparel → $13,144,009.63 

Beauty & Health → $10,309,285.95 

Home & Kitchen → $7,345,884.15 */

SELECT
c.category_name,
ROUND(SUM(oi.quantity * oi.unit_price),2) AS total_sales
FROM src_order_item oi
JOIN src_product p
ON oi.product_id = p.product_id
JOIN src_category c
ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sales DESC