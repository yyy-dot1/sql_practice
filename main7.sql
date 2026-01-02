-- SELECT
--     *,
--     CASE 
--         WHEN extension_fee >= 1000 THEN 300
--         WHEN extension_fee >= 400 THEN 100
--         ELSE 0
--     END AS snack_discount
-- FROM(
--     SELECT 
--     user_id,
--     (julianday(exit_time) - julianday(entry_time)) * 24 * 60 AS stay_minutes_1,
--     CASE
--         WHEN stay_minutes > 60  THEN CEIL((stay_minutes - 60) / 10) * 200 -- 延長料金
--         ELSE 0
--     END AS extension_fee
-- FROM visits
-- ) AS sub;

-- SELECT
--     *,
--     CASE 
--         WHEN extension_fee >= 1000 THEN 300
--         WHEN extension_fee >= 400 THEN 100
--         ELSE 0
--     END AS snack_discount
-- FROM(
--     SELECT
--         *,
--         CASE
--             WHEN stay_minutes > base_minutes THEN CEIL((stay_minutes - base_minutes) / 10.0) * 200
--             ELSE 0
--         END AS extension_fee
--     FROM(
--         SELECT
--             user_id,
--             plan_type,
--             base_minutes,
--             (julianday(exit_time) - julianday(entry_time)) * 24 * 60 AS stay_minutes
--         FROM visits
--     ) AS step1
-- ) AS step2;

-- SELECT
--     cat_name,
--     total_sales,
--     RANK() OVER(ORDER BY total_sales DESC,cat_name ASC) AS cat_rank
-- FROM (
--     SELECT 
--         cat_name,
--         SUM(snack_price) AS total_sales
--     FROM sales
--     GROUP BY cat_name
-- ) AS summary;

-- SELECT
--     CASE
--         WHEN(SELECT stock_qty FROM stocks WHERE item_name = 'カリカリ') >= (2 * 3)
--             AND (SELECT stock_qty FROM stocks WHERE item_name = 'ちゅーる') >= (1 * 3)
--         THEN '出荷OK'
--         WHEN(SELECT stock_qty FROM stocks WHERE item_name = 'カリカリ') < (2 * 3)
--         THEN 'カリカリ不足'
--         ELSE 'チュール不足'
--     END AS result;


SELECT
    'ちゅーる' AS item_name,
    3 AS required_qty,
    (SELECT stock_qty FROM stocks WHERE item_name = 'ちゅーる') AS current_stock,
    CASE
        WHEN(SELECT stock_qty FROM stocks WHERE item_name = 'ちゅーる') < 3
        THEN 3 - (SELECT stock_qty FROM stocks WHERE item_name = 'ちゅーる')
        ELSE 0
    END AS shortage_qty,

    CASE
        WHEN(SELECT stock_qty FROM stocks WHERE item_name = 'ちゅーる') >= 3 THEN 'OK'
        ELSE '不足'
    END AS status

    UNION ALL

    SELECT
    'カリカリ' AS item_name,
    6 AS required_qty,
    (SELECT stock_qty FROM stocks WHERE item_name = 'カリカリ') AS current_stock,
    
    CASE
        WHEN(SELECT stock_qty FROM stocks WHERE item_name = 'カリカリ') < 6
        THEN 6 - (SELECT stock_qty FROM stocks WHERE item_name = 'カリカリ')
        ELSE 0
    END AS shortage_qty,

    CASE
        WHEN(SELECT stock_qty FROM stocks WHERE item_name = 'カリカリ') >= 6 THEN 'OK'
        ELSE '不足'
    END AS status;