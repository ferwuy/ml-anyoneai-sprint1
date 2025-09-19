-- Query to get the number of orders per day in 2017 with holiday information
WITH orders_per_day AS (
    SELECT 
        DATE("order_purchase_timestamp") AS order_date,
        COUNT(*) AS order_count
    FROM 
        "olist_orders"
    WHERE 
        "order_purchase_timestamp" BETWEEN '2017-01-01' AND '2017-12-31'
    GROUP BY 
        DATE("order_purchase_timestamp")
)
SELECT 
    o.order_count,
    CAST(STRFTIME('%s', o.order_date) AS BIGINT) * 1000 AS date, -- Convert to Unix timestamp in milliseconds
    CASE 
        WHEN h.date IS NOT NULL THEN 1
        ELSE 0
    END AS holiday -- Boolean indicating if the day is a holiday
FROM 
    orders_per_day o
LEFT JOIN 
    "public_holidays" h
ON 
    o.order_date = DATE(h.date)
ORDER BY 
    o.order_date;

--### Explanation:
--1. **`WITH orders_per_day`**: This CTE calculates the number of orders per day in 2017, grouped by the date.
--2. **Convert Date to Unix Timestamp**: The `STRFTIME('%s', o.order_date)` function converts the date to a Unix timestamp in seconds, and multiplying by 1000 converts it to milliseconds.
--3. **Holiday Boolean**: The `CASE` statement checks if the `h.date` from the `public_holidays` table is not `NULL`. If it is not `NULL`, the day is a holiday (`1`), otherwise it is not (`0`).
--4. **Result Structure**: The query outputs `order_count`, `date` (in milliseconds), and `holiday` (as a boolean).
--5. **Order by Date**: The result is sorted by `order_date`.

--### Example Output:
--The query will produce results like this:

--| order_count | date           | holiday |
--|-------------|----------------|---------|
--| 216         | 1512172800000  | 0       |
--| 150         | 1512259200000  | 1       |