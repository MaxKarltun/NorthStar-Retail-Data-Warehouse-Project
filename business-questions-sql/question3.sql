/*Business Question 3 

Which customer segments generated the most revenue? 

Segment 

Revenue 

Regular 

$21,853,279.8 

Premium 

$20,157,503.0 

VIP 

$13,913,608.6 

Budget 

$11,086,297.0 

Figure 4 = Revenue by Customer Segment*/

SELECT
    c.segment,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM src_orders o
JOIN src_customer c
    ON o.customer_id = c.customer_id
JOIN src_order_item oi
    ON o.order_id = oi.order_id
GROUP BY c.segment
ORDER BY revenue DESC;

