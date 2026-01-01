
-- WITH total_stock AS(
--     SELECT 
--         product_id,
--         SUM(quantity) AS total_qty
--     FROM stock
--     GROUP BY product_id
-- ),

-- order_queue AS(
--     SELECT
--         order_id,
--         user_id,
--         product_id,
--         order_time,
--         user_rank,
--         SUM(order_qty) OVER(
--             PARTITION BY product_id
--             ORDER BY order_time ASC,user_rank = 'gold' DESC
--         ) AS cumulative_qty
--     FROM orders
-- ),

-- SELECT
--     warehouse_id,
--     product_id,
--     quantity,
--     SUM(quantity) OVER(
--         PARTITION BY product_id
--         ORDER BY warehouse_id ASC
--     ) AS running_stock
-- FROM stock;

WITH order_info AS(
    SELECT 6 AS order_qty,'p_001' AS product_id
),
stock_with_running AS(
    SELECT
        warehouse_id,
        product_id,
        quantity AS current_stock,
        -- 並べた値の中から、最初に見つかったNULLじゃない値(=0)を返す
        COALESCE(SUM(quantity) OVER(
            PARTITION BY product_id
            ORDER BY warehouse_id ASC
            -- 最初の行に「1つ前」が存在しない
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ),0) AS prev_running_stock, -- 1つ前がないなら、これまでの出荷数は 0個だよ
        -- 全量をproduct_idでグループ化して、倉庫IDで昇順にする
        SUM(quantity) OVER(
        -- product_idごとに0から累積
            PARTITION BY product_id
        -- 累積結果をwarehouse_idごとに分ける
            ORDER BY warehouse_id ASC
        )AS current_running_stock
    FROM stock
)
SELECT
    s.warehouse_id,
    s.current_stock,
    o.order_qty AS 総注文数,
    CASE
    --
        WHEN s.prev_running_stock <= o.order_qty THEN 0
        WHEN s.current_running_stock >= o.order_qty
            THEN o.order_qty - s.prev_running_stock
        ELSE s.current_stock
    END AS 出荷指示数
FROM stock_with_running s
JOIN order_info o ON s.product_id = o.product_id;

