---Rejected order items
SELECT 
order_item_id,
order_id,
product_id,
seller_id,
CAST(quantity AS INT) AS quaNtity,
CAST(unit_price AS DECIMAL(12,2)) AS unit_price,
CAST(discount_amount AS DECIMAL(12,2)) AS discount_amount
INTO qa.rejected_order_items FROM raw.order_items
WHERE CAST(quantity AS INT) <= 0;
---DROP TABLE qa.rejected_order_items

SELECT COUNT(*) FROM qa.rejected_order_items

---Rejected reviews
SELECT 
review_id,
order_id,
TRY_CAST(review_score AS INT) AS review_score,
review_date,
review_comment 
INTO qa.rejected_reviews
FROM raw.reviews
WHERE CAST(review_score AS INT) < 1 OR CAST(review_score AS INT) > 5 OR  CAST(review_score AS INT) IS NULL

SELECT COUNT(*) FROM qa.rejected_reviews
---DROP TABLE  qa.rejected_reviews