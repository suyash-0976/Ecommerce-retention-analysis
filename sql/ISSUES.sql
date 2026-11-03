---changes 
USE EcomRetentionDB;
GO

TRUNCATE TABLE raw.customers;
BULK INSERT raw.customers FROM 'D:\New folder\spx project pro1\raw\customers.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, CODEPAGE = '65001');

TRUNCATE TABLE raw.orders;
BULK INSERT raw.orders FROM 'D:\New folder\orders.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, CODEPAGE = '65001');

TRUNCATE TABLE raw.deliveries;
BULK INSERT raw.deliveries FROM 'D:\New folder\spx project pro1\raw\deliveries.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, CODEPAGE = '65001');

TRUNCATE TABLE raw.reviews;
BULK INSERT raw.reviews FROM 'D:\New folder\spx project pro1\raw\reviews.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, CODEPAGE = '65001');
GO
SELECT COUNT(*) FROM raw.orders

SELECT TOP 3 order_date FROM raw.orders;

SELECT
    SUM(CASE WHEN order_date LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]' THEN 1 ELSE 0 END) AS iso_rows,
    SUM(CASE WHEN order_date LIKE '[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]' THEN 1 ELSE 0 END) AS slash_rows,
    SUM(CASE WHEN order_date LIKE '[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]' THEN 1 ELSE 0 END) AS dash_rows
FROM raw.orders;

TRUNCATE TABLE raw.orders;
SELECT COUNT(*) AS rows_after_truncate FROM raw.orders;

BULK INSERT raw.orders
FROM 'D:\Personal_Projects\spx project pro1\raw\orders.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, CODEPAGE = '65001');
GO

SELECT COUNT(*) AS order_rows FROM raw.orders;
SELECT order_date FROM raw.orders WHERE order_id = 'ORD016385';