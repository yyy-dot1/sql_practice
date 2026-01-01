SELECT 
    warehouse_id,
    COUNT(DISTINCT product_id) AS product_types,
    CASE
        WHEN MIN(quantity) <= 0 THEN '要確認' ELSE 'OK' END AS stock_status,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_id_count
FROM stocks
GROUP BY warehouse_id;