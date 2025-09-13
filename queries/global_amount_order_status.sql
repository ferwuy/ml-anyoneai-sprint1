-- TODO: 
-- This query will return a table with two columns: order_status and Amount. 
-- The first one will have the different order status classes 
-- and the second one the total amount of each.

SELECT 
    "order_status",
    COUNT(*) AS "Amount"
FROM 
    "olist_orders"
GROUP BY 
    "order_status"


--### Explanation:
--1. **COUNT(*)**: Counts the number of rows (orders) for each `order_status`.
--2. **GROUP BY**: Groups the data by `order_status` to calculate the count for each status.
--3. **ORDER BY**: Orders the results in descending order of the count (`Amount`).
