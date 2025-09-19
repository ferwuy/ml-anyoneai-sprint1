SELECT 
    oi.order_id,
    oi.freight_value,
    p.product_weight_g
FROM 
    olist_order_items AS oi
JOIN 
    olist_products AS p
ON 
    oi.product_id = p.product_id

--### Explanation:
--1. **Join Tables**: The `olist_order_items` table is 
--joined with the `olist_products` table using the `product_id` column 
--to link freight values with product weights.