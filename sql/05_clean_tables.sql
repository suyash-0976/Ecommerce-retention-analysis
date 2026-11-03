----cleaning
SELECT TOP 10 * FROM raw.products
USE EcomRetentionDB
---Clean customers

SELECT 
DISTINCT 
customer_id,
customer_name,
city = COALESCE(NULLIF(city,''),'Unknown'),
state,
pincode = COALESCE(NULLIF(pincode,''),'Unknown'),
signup_date
INTO clean.customers
FROM raw.customers 

---confirming
SELECT COUNT(*) AS CLEAN FROM (SELECT DISTINCT 
customer_id,
customer_name,
city = COALESCE(NULLIF(city,''),'Unknown'),
state,
pincode = COALESCE(NULLIF(pincode,''),'Unknown'),
signup_date
FROM raw.customers)AS t

SELECT count(*) FROM ( SELECT* FROM clean_customers) AS ad

SELECT count(*) FROM ( SELECT* FROM clean_customers
WHERE city = 'Unknown') AS y
SELECT TOP 5 * FROM clean.customers;

---Clean products
SELECT
product_id,
product_name,
CASE LOWER(LTRIM(RTRIM(categroy)))
        WHEN 'kitchen'    THEN 'Kitchen'
        WHEN 'home decor' THEN 'Home Decor'
        WHEN 'bedroom'    THEN 'Bedroom'
        WHEN 'storage'    THEN 'Storage'
        WHEN 'bath'       THEN 'Bath'
        WHEN 'lighting'   THEN 'Lighting'
        WHEN 'garden'     THEN 'Garden'
        ELSE 'Unknown'
END AS category,
brand,
CAST(mrp AS DECIMAL(10,2)) AS mrp
INTO clean.products
FROM raw.products;
---upper(left(LTRIM(RTRIM(categroy)),1)) + LOWER(SUBSTRING(LTRIM(RTRIM(categroy)),2,100)) AS category,
SELECT category, COUNT(*) AS n FROM clean.products GROUP BY category;

---Clean orders
SELECT 
DISTINCT order_id,
customer_id,
TRY_CONVERT(date,order_date,105) AS order_date,
order_status,
TRIM(channel) as channel
INTO clean.orders
FROM raw.orders

SELECT COUNT(*) AS clean_rows FROM clean.orders;
SELECT COUNT(*) AS null_dates FROM clean.orders WHERE order_date IS NULL;

---clean.order_items
SELECT DISTINCT
order_item_id,
order_id,
product_id,
seller_id,
CAST(quantity AS INT) AS quantity,
CAST(unit_price AS DECIMAL(12,2)) AS unit_price,
CAST(discount_amount AS DECIMAL(12,2)) AS discount_amount
INTO clean.order_items
FROM raw.order_items
WHERE CAST(quantity AS INT) > 0;
---DROP TABLE clean.order_items

SELECT COUNT(*) AS clean_rows FROM clean.order_items;
SELECT COUNT(*) AS bad_qty FROM clean.order_items WHERE CAST(quantity AS INT) <= 0;
---DROP TABLE clean.order_items

---Clean payments
SELECT 
payment_id,
order_id,
payment_type,
CAST(payment_installments AS INT) AS payment_installments,
REPLACE(REPLACE(payment_values,N'₹',''),',','') AS payment_values
INTO clean.payments
FROM raw.payments;

SELECT COUNT(*) FROM clean.payments
SELECT COUNT(*) FROM clean.payments WHERE payment_values IS NULL;

---Clean deliveries
SELECT
delivery_id,
order_id,
TRY_CONVERT(date,shipped_date,105) AS shipped_date,
TRY_CONVERT(date,estimated_delivery_date,105) AS estimated_delivery_date,
TRY_CONVERT(date,delivered_date,105) AS delivered_date,
courier,
delivery_status,
CASE
WHEN TRY_CONVERT(date,shipped_date,105) > TRY_CONVERT(date,delivered_date,105) THEN NULL
WHEN TRY_CONVERT(date,shipped_date,105) < TRY_CONVERT(date,delivered_date,105) THEN 'OK'
ELSE 'unkown' 
END AS real_or_not,
CASE
WHEN TRY_CONVERT(date,shipped_date,105) > TRY_CONVERT(date,delivered_date,105) THEN 1
ELSE 0 
END AS date_issue_flag 
INTO clean.deliveries
FROM raw.deliveries

SELECT COUNT(*) FROM (SELECT * FROM clean.deliveries
WHERE date_issue_flag= 1) AS df;
SELECT COUNT(*) FROM (SELECT * FROM clean.deliveries) AS dt;
---DROP TABLE clean.deliveries

---Clean reviews
SELECT 
review_id,
order_id,
CAST(review_score AS INT) AS review_score,
TRY_CONVERT(date,review_date,105) AS review_date,
NULLIF(review_comment,'') AS review_comment
INTO clean.reviews
FROM raw.reviews
WHERE CAST(review_score AS INT) BETWEEN 1 AND 5

SELECT COUNT(*) FROM clean.reviews;
SELECT COUNT(*) FROM clean.reviews 
WHERE review_score NOT BETWEEN 0 AND 5

---Clean sellers
SELECT 
seller_id,
seller_name,
seller_city,
seller_state,
CAST(seller_rating AS DECIMAL(3,1)) AS seller_rating
INTO clean.seller
FROM raw.sellers;

SELECT COUNT(*) FROM clean.seller
SELECT MIN(seller_rating),MAX(seller_rating) FROM clean.seller



---Reconcile order items
SELECT COUNT(DISTINCT order_item_id) FROM raw.order_items;
SELECT COUNT(DISTINCT order_item_id)AS RAW FROM raw.order_items
SELECT COUNT(order_item_id) FROM raw.order_items;

---Integrity check on orders
SELECT * FROM  clean.orders 
SELECT * FROM clean.customers;

SELECT 
COUNT(*) AS orphoned
FROM clean.orders AS c
LEFT JOIN clean.customers AS a
ON c.customer_id = a.customer_id
WHERE a.customer_id IS NULL

---Integrity check on payments
SELECT * FROM clean.payments
SELECT 
COUNT(*) as count
FROM clean.payments AS p
LEFT JOIN clean.orders AS o 
ON p.order_id = o.order_id
WHERE o.order_id IS NULL

---Integrity check on deliveries
SELECT * FROM clean.deliveries
SELECT * FROM clean.orders
SELECT COUNT(*) AS Cout
FROM clean.deliveries AS d
LEFT JOIN clean.orders AS o
ON d.order_id = o.order_id 
WHERE o.order_id IS NULL

---Revenue per delivered order (mart view)
SELECT TOP 5 * FROM clean.orders
SELECT TOP 5 * FROM clean.order_items 
