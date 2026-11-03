--creating tables

USE EcomRetentionDB;

CREATE TABLE raw.customers(
	customer_id VARCHAR(50),
	customer_name VARCHAR(100),
	city VARCHAR(50),
	state VARCHAR(50),
	pincode VARCHAR(20),
	signup_date VARCHAR(50)
)

SELECT * FROM raw.order_items;
---DROP TABLE raw.customers;

CREATE TABLE raw.deliveries(
	delivery_id VARCHAR(50),
	order_id VARCHAR(50),
	shipped_date VARCHAR(20),
	estimated_delivery_date VARCHAR(20),
	delivered_date VARCHAR(20),
	courier VARCHAR(50),
	delivery_status VARCHAR(30)
)

CREATE TABLE raw.order_items(
	order_item_id VARCHAR(50),
	order_id VARCHAR(50),
	product_id VARCHAR(50),
	seller_id VARCHAR(50),
	quantity VARCHAR(10),
	unit_price NVARCHAR(20),
	discount_amount VARCHAR(20)
)


CREATE TABLE raw.orders(
	order_id VARCHAR(50),
	customer_id VARCHAR(50),
	order_date VARCHAR(20),
	order_status VARCHAR(20),
	channel VARCHAR(20)
)

CREATE TABLE raw.payments(
	payment_id VARCHAR(50),
	order_id VARCHAR(50),
	payment_type VARCHAR(30),
	payment_installments VARCHAR(10),
	payment_values VARCHAR(30)
)

CREATE TABLE raw.products(
	product_id VARCHAR(50),
	product_name VARCHAR(100),
	categroy VARCHAR(50),
	brand VARCHAR(50),
	mrp VARCHAR(20)
)

CREATE TABLE raw.reviews(
	review_id VARCHAR(50),
	order_id VARCHAR(50),
	review_score VARCHAR(10),
	review_date VARCHAR(20),
	review_comment VARCHAR(500)
)

CREATE TABLE raw.sellers(
	seller_id VARCHAR(50),
	seller_name VARCHAR(100),
	seller_city VARCHAR(50),
	seller_state VARCHAR(50),
	seller_rating VARCHAR(10)
)
