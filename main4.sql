-- SELECT 
--     warehouse_id,
--     COUNT(DISTINCT product_id) AS product_types,
--     COUNT(DISTINCT CASE WHEN quantity > 100 THEN product_id ELSE NULL END)
-- FROM stocks
-- GROUP BY warehouse_id;

SELECT 
    COUNT(*) AS heavy_stock_product_count
FROM(
    SELECT product_id
    FROM stocks
    GROUP BY product_id 
    HAVING SUM(quantity) > 100
)
