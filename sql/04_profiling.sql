----- Profiling: duplicate customers 
USE EcomRetentionDB;

SELECT customer_id,Count(*) as Duplicate FROM raw.customers
	GROUP BY customer_id
	HAVING Count(*)>1

SELECT * FROM raw.order_items

-----Blank or null city
SELECT COUNT(*) AS Null_city
	FROM raw.Customers 
	WHERE city IS null OR city=' '

-----Blank or null pincode
SELECT COUNT(*) AS Null_pin
FROM raw.Customers
WHERE pincode IS NULL OR pincode = ' ';

---Bad quantities in order items
SELECT Count(*) as bad_quantity_rows
FROM raw.order_items
WHERE CAST(quantity AS INT)< = 0

---Orphan products in order items
SELECT 
count(*) AS oprhaned,
p.product_id
FROM raw.order_items as p  
LEFT JOIN 
raw.products as a
on p.product_id = a.product_id
WHERE a.product_id IS NULL 
GROUP BY P.product_id

SELECT * FROM raw.payments

---Rupee text in payments
SELECT TOP 5 TRY_CAST(payment_values AS DECIMAL(12,2))AS counts FROM raw.payments
WHERE TRY_CAST(payment_values AS DECIMAL(12,2)) IS NULL

SELECT TOP 5 * FROM raw.payments

SELECT TOP 5 payment_values,
       LEN(payment_values) AS len_value,
       TRY_CAST(payment_values AS DECIMAL(12,2)) AS converted
FROM raw.payments;

SELECT COUNT(*) AS BAD_PAYMENTS FROM raw.payments
WHERE payment_values IS NOT NULL
AND TRY_CAST(payment_values AS DECIMAL(12,2)) IS NULL

---Deliveries that arrived before they shipped
SELECT COUNT(*) AS ANOMOLY FROM raw.deliveries
WHERE TRY_CAST(delivered_date AS DATE) < TRY_CAST(shipped_date  AS DATE)

SELECT TOP 10 shipped_date, delivered_date FROM raw.deliveries
where TRY_CAST(shipped_date AS DATE) IS NULL

SELECT COUNT(*) AS ANOMOLY FROM raw.deliveries 
WHERE TRY_CONVERT(DATE,delivered_date,105) <TRY_CONVERT(DATE,shipped_date,105)

---Format check on order dates
SELECT * FROM raw.orders;
SELECT 
SUM(CASE WHEN TRY_CONVERT(DATE,order_date,23) IS NOT NULL THEN 1 ELSE  0 END) AS iso_format,
SUM(CASE WHEN TRY_CONVERT(DATE,order_date,103) IS NOT NULL THEN 1 ELSE  0 END) AS slash_format
FROM raw.orders

SELECT 
    SUM(CASE WHEN TRY_CONVERT(DATE, order_date, 23) IS NOT NULL THEN 1 ELSE 0 END) AS iso_format_count,
    SUM(CASE WHEN TRY_CONVERT(DATE, order_date, 23) IS NULL AND TRY_CONVERT(DATE, order_date, 103) IS NOT NULL THEN 1 ELSE 0 END) AS slash_format_count,
    SUM(CASE WHEN TRY_CONVERT(DATE, order_date, 23) IS NULL AND TRY_CONVERT(DATE, order_date, 103) IS NULL THEN 1 ELSE 0 END) AS neither_format_count
FROM raw.orders;

---Review scores outside 1 to 5
USE EcomRetentionDB;
SELECT COUNT(*) AS Errored_review FROM raw.reviews
WHERE TRY_CAST(review_score AS INT)< 1 OR TRY_CAST(review_score AS INT)> 5

---Duplicate order items
SELECT COUNT(DISTINCT order_item_id) AS non_repetative ,COUNT(order_item_id) AS repeted,
(COUNT(order_item_id) - COUNT(DISTINCT order_item_id))AS NO_OF_DUPLICATE
FROM raw.order_items

---Duplicate orders
SELECT COUNT(DISTINCT order_id) AS non_repetative ,COUNT(order_id) AS repeted,
(COUNT(order_id) - COUNT(DISTINCT order_id))AS NO_OF_DUPLICATE
FROM raw.orders
SELECT TOP 5 * FROM raw.orders

---Product categories in uppercase
SELECT COUNT(*) AS unkown
FROM raw.products
WHERE categroy COLLATE Latin1_General_CS_AS = UPPER(Categroy) COLLATE Latin1_General_CS_AS

---Product categories with trailing spaces
SELECT COUNT(*) AS more_space
FROM raw.products
WHERE DATALENGTH(RTRIM(categroy)) <> DATALENGTH(categroy)

SELECT TOP 5 * FROM raw.customers;
--- Duplicate customers (total extra copies)
SELECT 
COUNT(*),
COUNT(DISTINCT customer_id),
(COUNT(*) - COUNT(DISTINCT customer_id))  AS Duplicate_customers 
FROM raw.customers;
---Deliveries that arrived before they shipped
SELECT COUNT(*) AS ANOMOLY FROM raw.deliveries
WHERE TRY_CAST(delivered_date AS DATE) < TRY_CAST(shipped_date  AS DATE)

SELECT TOP 10 shipped_date, delivered_date FROM raw.deliveries
where TRY_CAST(shipped_date AS DATE) IS NULL

SELECT COUNT(*) AS ANOMOLY FROM raw.deliveries 
WHERE TRY_CONVERT(DATE,delivered_date,105) <TRY_CONVERT(DATE,shipped_date,105)

---Format check on order dates
SELECT * FROM raw.orders;
SELECT 
SUM(CASE WHEN TRY_CONVERT(DATE,order_date,23) IS NOT NULL THEN 1 ELSE  0 END) AS iso_format,
SUM(CASE WHEN TRY_CONVERT(DATE,order_date,103) IS NOT NULL THEN 1 ELSE  0 END) AS slash_format
FROM raw.orders

SELECT 
    SUM(CASE WHEN TRY_CONVERT(DATE, order_date, 23) IS NOT NULL THEN 1 ELSE 0 END) AS iso_format_count,
    SUM(CASE WHEN TRY_CONVERT(DATE, order_date, 23) IS NULL AND TRY_CONVERT(DATE, order_date, 103) IS NOT NULL THEN 1 ELSE 0 END) AS slash_format_count,
    SUM(CASE WHEN TRY_CONVERT(DATE, order_date, 23) IS NULL AND TRY_CONVERT(DATE, order_date, 103) IS NULL THEN 1 ELSE 0 END) AS neither_format_count
FROM raw.orders;

