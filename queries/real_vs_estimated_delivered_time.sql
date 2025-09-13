-- TODO: 
-- This query will return a table with the differences between the real 
-- and estimated delivery times by month and year. 
-- It will have different columns: 
--      month_no, with the month numbers going FROM 01 to 12; 
--      month, with the 3 first letters of each month (e.g. Jan, Feb); 
--      Year2016_real_time, with the average delivery time per month of 2016 (NaN if it doesn't exist); 
--      Year2017_real_time, with the average delivery time per month of 2017 (NaN if it doesn't exist); 
--      Year2018_real_time, with the average delivery time per month of 2018 (NaN if it doesn't exist); 
--      Year2016_estimated_time, with the average estimated delivery time per month of 2016 (NaN if it doesn't exist); 
--      Year2017_estimated_time, with the average estimated delivery time per month of 2017 (NaN if it doesn't exist) and 
--      Year2018_estimated_time, with the average estimated delivery time per month of 2018 (NaN if it doesn't exist).

-- HINTS:
-- 1. You can use the julianday function to convert a date to a number.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Take distinct order_id.

--1. **Filter Orders**: Include only orders with `order_status = 'delivered'` and non-null `order_delivered_customer_date`.

--2. **Calculate Delivery Times**:
--   - Real delivery time: Difference between `order_delivered_customer_date` and `order_purchase_timestamp`.
--   - Estimated delivery time: Difference between `order_estimated_delivery_date` and `order_purchase_timestamp`.

--3. **Group by Month and Year**:
--   - Extract the month and year from `order_purchase_timestamp`.
--   - Calculate the average real and estimated delivery times for each month and year.

--4. **Pivot the Data**:
--   - Use conditional aggregation to create separate columns for each year (2016, 2017, 2018) for both real and estimated delivery times.

--Here’s the efficient SQL query:

WITH delivery_times AS (
    SELECT
        DISTINCT o."order_id",
        STRFTIME('%Y', o."order_purchase_timestamp") AS "year",
        STRFTIME('%m', o."order_purchase_timestamp") AS "month_no",
        STRFTIME('%m', o."order_purchase_timestamp") || '-' || STRFTIME('%Y', o."order_purchase_timestamp") AS "month_year",
        SUBSTR(UPPER(STRFTIME('%m', o."order_purchase_timestamp", 'start of month')), 1, 3) AS "month",
        JULIANDAY(o."order_delivered_customer_date") - JULIANDAY(o."order_purchase_timestamp") AS "real_time",
        JULIANDAY(o."order_estimated_delivery_date") - JULIANDAY(o."order_purchase_timestamp") AS "estimated_time"
    FROM
        olist_orders o
    WHERE
        o."order_status" = 'delivered'
        AND o."order_delivered_customer_date" IS NOT NULL
),
aggregated_times AS (
    SELECT
        "month_no",
        CASE month_no
            WHEN '01' THEN 'Jan'
            WHEN '02' THEN 'Feb'
            WHEN '03' THEN 'Mar'
            WHEN '04' THEN 'Apr'
            WHEN '05' THEN 'May'
            WHEN '06' THEN 'Jun'
            WHEN '07' THEN 'Jul'
            WHEN '08' THEN 'Aug'
            WHEN '09' THEN 'Sep'
            WHEN '10' THEN 'Oct'
            WHEN '11' THEN 'Nov'
            WHEN '12' THEN 'Dec'
        END AS "month",
        AVG(CASE WHEN "year" = '2016' THEN "real_time" END) AS "Year2016_real_time",
        AVG(CASE WHEN "year" = '2017' THEN "real_time" END) AS "Year2017_real_time",
        AVG(CASE WHEN "year" = '2018' THEN "real_time" END) AS "Year2018_real_time",
        AVG(CASE WHEN "year" = '2016' THEN "estimated_time" END) AS "Year2016_estimated_time",
        AVG(CASE WHEN "year" = '2017' THEN "estimated_time" END) AS "Year2017_estimated_time",
        AVG(CASE WHEN "year" = '2018' THEN "estimated_time" END) AS "Year2018_estimated_time"
    FROM
        delivery_times
    GROUP BY
        "month_no", "month"
)
SELECT
    "month_no",
    "month",
    "Year2016_real_time",
    "Year2017_real_time",
    "Year2018_real_time",
    "Year2016_estimated_time",
    "Year2017_estimated_time",
    "Year2018_estimated_time"
FROM
    aggregated_times
ORDER BY
    CAST("month_no" AS INTEGER);

--### Explanation of the Query:

--1. **`delivery_times` CTE**:
--   - Filters only delivered orders with valid delivery dates.
--   - Calculates `real_time` and `estimated_time` using the `JULIANDAY` function.
--   - Extracts the year (`%Y`), month number (`%m`), and month abbreviation (`%m` with `start of month`).

--2. **`aggregated_times` CTE**:
--   - Groups the data by `month_no` and `month`.
--   - Uses conditional aggregation (`CASE WHEN`) to calculate the average real and estimated delivery times for each year (2016, 2017, 2018).

--3. **Final SELECT**:
--   - Selects the required columns and orders the results by `month_no` to ensure the months are displayed in chronological order.

--### Output Columns:
--- **month_no**: The month number (01 to 12).
--- **month**: The 3-letter abbreviation of the month (e.g., Jan, Feb).
--- **Year2016_real_time**: Average real delivery time for 2016 (or `NaN` if no data exists).
--- **Year2017_real_time**: Average real delivery time for 2017 (or `NaN` if no data exists).
--- **Year2018_real_time**: Average real delivery time for 2018 (or `NaN` if no data exists).
--- **Year2016_estimated_time**: Average estimated delivery time for 2016 (or `NaN` if no data exists).
--- **Year2017_estimated_time**: Average estimated delivery time for 2017 (or `NaN` if no data exists).
--- **Year2018_estimated_time**: Average estimated delivery time for 2018 (or `NaN` if no data exists).
