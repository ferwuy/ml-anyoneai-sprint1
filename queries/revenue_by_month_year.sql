-- TODO: 
-- This query will return a table with the revenue by month and year. 
-- It will have different columns: 
--      month_no, with the month numbers going from 01 to 12; 
--      month, with the 3 first letters of each month (e.g. Jan, Feb); 
--      Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist); 
--      Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and 
--      Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).

-- HINTS:
-- 1. olist_order_payments has multiple entries for some order_id values. 
-- For this query, make sure to retain only the entry with minimal payment_value for each order_id.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL


-- To create the query as described, we need to calculate the revenue by month and year while adhering to the following steps:

-- 1. **Filter the data**:
--    - Only include orders with `order_status = 'delivered'` and `order_delivered_customer_date IS NOT NULL`.
--    - Use the `olist_order_payments` table to calculate revenue, but only consider the entry with the **minimal `payment_value`** for each `order_id`.

-- 2. **Extract the year and month**:
--    - Use the `strftime` function to extract the year and month from the `order_delivered_customer_date`.

-- 3. **Aggregate revenue**:
--    - Group by year and month, and calculate the total revenue for each combination.

-- 4. **Pivot the data**:
--    - Create columns for `Year2016`, `Year2017`, and `Year2018` with revenue values for each year.

-- 5. **Format the output**:
--    - Include `month_no` (01 to 12) and `month` (e.g., Jan, Feb) columns.


WITH FilteredOrders AS (
    -- Step 1: Filter orders with 'delivered' status and non-NULL delivery dates
    SELECT 
        o."order_id",
        o."order_delivered_customer_date",
        MIN(p."payment_value") AS min_payment_value
    FROM 
        "olist_orders" o
    JOIN 
        "olist_order_payments" p
    ON 
        o."order_id" = p."order_id"
    WHERE 
        o."order_status" = 'delivered'
        AND o."order_delivered_customer_date" IS NOT NULL
    GROUP BY 
        o."order_id", o."order_delivered_customer_date"
),
RevenueByMonth AS (
    -- Step 2: Extract year and month, and calculate total revenue
    SELECT 
        strftime('%Y', "order_delivered_customer_date") AS year,
        strftime('%m', "order_delivered_customer_date") AS month_no,
        SUM("min_payment_value") AS revenue
    FROM 
        FilteredOrders
    GROUP BY 
        year, month_no
),
PivotedRevenue AS (
    -- Step 3: Pivot the data to create columns for Year2016, Year2017, and Year2018
    SELECT 
        month_no,
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
        END AS month,
        COALESCE(SUM(CASE WHEN year = '2016' THEN revenue END), 0.00) AS Year2016,
        COALESCE(SUM(CASE WHEN year = '2017' THEN revenue END), 0.00) AS Year2017,
        COALESCE(SUM(CASE WHEN year = '2018' THEN revenue END), 0.00) AS Year2018
    FROM 
        RevenueByMonth
    GROUP BY 
        month_no
    ORDER BY 
        month_no
)
-- Step 4: Final output
SELECT 
    month_no, 
    month, 
    Year2016, 
    Year2017, 
    Year2018
FROM 
    PivotedRevenue;

-- ### Explanation of the Query:
-- 1. **`FilteredOrders` CTE**:
--    - Filters the orders to include only those with `order_status = 'delivered'` and a non-NULL `order_delivered_customer_date`.
--    - Retains only the entry with the minimal `payment_value` for each `order_id`.

-- 2. **`RevenueByMonth` CTE**:
--    - Extracts the year (`strftime('%Y')`) and month (`strftime('%m')`) from the `order_delivered_customer_date`.
--    - Aggregates the revenue (`SUM(min_payment_value)`) by year and month.

-- 3. **`PivotedRevenue` CTE**:
--    - Pivots the data to create separate columns for revenue in 2016, 2017, and 2018.
--    - Uses `CASE` statements to conditionally sum the revenue for each year.
--    - Uses `COALESCE` to ensure that missing values are replaced with `0.00`.

-- 4. **Final Output**:
--    - Selects the `month_no`, `month`, and revenue columns for each year.
--    - Orders the results by `month_no`.

-- ### Example Output:
-- | month_no | month | Year2016 | Year2017 | Year2018 |
-- |----------|-------|----------|----------|----------|
-- | 01       | Jan   | 0.00     | 12345.67 | 23456.78 |
-- | 02       | Feb   | 0.00     | 34567.89 | 45678.90 |
-- | ...      | ...   | ...      | ...      | ...      |