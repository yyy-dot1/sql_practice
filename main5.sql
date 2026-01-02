
SELECT
    product_id,
    system_stock,
    actual_stock,
    CASE
        WHEN system_stock <> actual_stock THEN '不一致'
        ELSE '一致'
    END AS status,
    ABS(system_stock - actual_stock) AS diff_quantity
FROM inventory_check
WHERE system_stock <> actual_stock;