---CREATE VIEW mart.vw_order_revenue AS 
CREATE OR ALTER VIEW mart.vw_order_revenue AS
SELECT
o.order_id,
o.customer_id,
o.order_date,
o.order_status,
o.channel,
sum(i.quantity*i.unit_price )AS order_revenue
FROM clean.orders AS o
LEFT JOIN clean.order_items AS i 
ON o.order_id = i.order_id 
WHERE o.order_status = 'delivered'
GROUP BY o.order_id ,
o.customer_id,
o.order_date,
o.order_status,
o.channel

SELECT COUNT(*) FROM mart.vw_order_revenue
SELECT COUNT(*) FROM clean.orders WHERE order_status = 'delivered'

----Delivery performance (mart view)
CREATE OR ALTER VIEW  mart.vw_delivery_performance AS
SELECT 
delivery_id,
order_id,
courier,
delivery_status,
estimated_delivery_date,
delivered_date,
DATEDIFF(day,estimated_delivery_date,delivered_date) AS delay_days,
CASE 
WHEN delivered_date IS NULL THEN NULL
WHEN delivered_date <= estimated_delivery_date THEN 1
ELSE 0
END AS on_time_flag
FROM clean.deliveries

SELECT COUNT(*) FROM  mart.vw_delivery_performance 
SELECT COUNT(*) FROM  mart.vw_delivery_performance WHERE delay_days>0;
