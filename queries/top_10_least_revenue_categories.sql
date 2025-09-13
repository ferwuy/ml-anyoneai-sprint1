-- TODO: 
-- This query will return a table with the top 10 least revenue categories 
-- in English, the number of orders and their total revenue. 
-- It will have different columns: 
--      Category, that will contain the top 10 least revenue categories; 
--      Num_order, with the total amount of orders of each category; 
--      Revenue, with the total revenue of each category.

-- HINT: 
-- All orders should have a delivered status and the Category and actual delivery date should be not null.
-- For simplicity, if there are orders with multiple product categories, consider the full order's payment_value in the summation of revenue of each category

--1.**Filter Orders**: Only include orders with order_status= 'delivered' and non-null 'order_delivered_customer_date'

--2. **Join Tables**:
--   - Join `olist_orders` with `olist_order_items` to get product details for each order.
--   - Join `olist_order_items` with `olist_products` to get the product category.
--   - Join `olist_products` with `product_category_name_translation` to get the English names of the categories.
--   - Join `olist_orders` with `olist_order_payments` to get the payment value for each order.

--3. **Aggregate Data**:
-- - Group by the product category (in English).
-- - Count the number of orders (`Num_order`) and sum the payment values (`Revenue`).

--4. **Sort and Limit**:
-- - Sort the results by `Revenue` in ascending order.
-- - Limit the output to the top 10 least revenue categories.

WITH category_revenue AS (
    SELECT
        t."product_category_name_english" AS "Category",
        COUNT(DISTINCT o."order_id") AS "Num_order",
        SUM(p."payment_value") AS "Revenue"
    FROM
        olist_orders o
    JOIN
        olist_order_items oi ON o."order_id" = oi."order_id"
    JOIN
        olist_products pr ON oi."product_id" = pr."product_id"
    JOIN
        product_category_name_translation t ON pr."product_category_name" = t."product_category_name"
    JOIN
        olist_order_payments p ON o."order_id" = p."order_id"
    WHERE
        o."order_status" = 'delivered'
        AND o."order_delivered_customer_date" IS NOT NULL
        AND t."product_category_name_english" IS NOT NULL
    GROUP BY
        t."product_category_name_english"
)
SELECT
    "Category",
    "Num_order",
    "Revenue"
FROM
    category_revenue
ORDER BY
    "Revenue" ASC
LIMIT 10;

--### Explanation of the Query:
--1. **Filtering**:
--   - The `WHERE` clause ensures that only delivered orders with a valid delivery date and non-null category names are included.

--2. **Aggregation**:
--   - `COUNT(DISTINCT o."order_id")` counts the unique orders for each category.
--   - `SUM(p."payment_value")` calculates the total revenue for each category.

--3. **Sorting and Limiting**:
--   - The `ORDER BY "Revenue" ASC` ensures the categories are sorted by revenue in ascending order.
--   - `LIMIT 10` restricts the output to the top 10 least revenue categories.
