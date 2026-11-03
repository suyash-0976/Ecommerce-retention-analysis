
USE EcomRetentionDB;
GO

BULK INSERT raw.customers
FROM 'D:\Personal_Projects\spx project pro1\raw\customers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);
GO

SELECT COUNT(*) AS customer_rows FROM raw.customers;

BULK INSERT raw.products FROM 'D:\Personal_Projects\spx project pro1\raw\products.csv' WITH (FORMAT = 'CSV', FIRSTROW = 2, CODEPAGE = '65001');
BULK INSERT raw.sellers FROM 'D:\Personal_Projects\spx project pro1\raw\sellers.csv' WITH (FORMAT = 'CSV', FIRSTROW = 2, CODEPAGE = '65001');
BULK INSERT raw.orders FROM 'D:\Personal_Projects\spx project pro1\raw\orders.csv' WITH (FORMAT = 'CSV', FIRSTROW = 2, CODEPAGE = '65001');
BULK INSERT raw.order_items FROM 'D:\Personal_Projects\spx project pro1\raw\order_items.csv' WITH (FORMAT = 'CSV', FIRSTROW = 2, CODEPAGE = '65001');
BULK INSERT raw.payments FROM 'D:\Personal_Projects\spx project pro1\raw\payments.csv' WITH (FORMAT = 'CSV', FIRSTROW = 2, CODEPAGE = '65001');
BULK INSERT raw.deliveries FROM 'D:\Personal_Projects\spx project pro1\raw\deliveries.csv' WITH (FORMAT = 'CSV', FIRSTROW = 2, CODEPAGE = '65001');
BULK INSERT raw.reviews FROM 'D:\Personal_Projects\spx project pro1\raw\reviews.csv' WITH (FORMAT = 'CSV', FIRSTROW = 2, CODEPAGE = '65001');
GO

SELECT 'products' AS tbl, COUNT(*) AS n FROM raw.products UNION ALL
SELECT 'sellers', COUNT(*) FROM raw.sellers UNION ALL
SELECT 'orders', COUNT(*) FROM raw.orders UNION ALL
SELECT 'order_items', COUNT(*) FROM raw.order_items UNION ALL
SELECT 'payments', COUNT(*) FROM raw.payments UNION ALL
SELECT 'deliveries', COUNT(*) FROM raw.deliveries UNION ALL
SELECT 'reviews', COUNT(*) FROM raw.reviews;

