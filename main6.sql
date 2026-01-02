
-- SELECT
--     o.user_id,
--     SUM((o.unit_price * o.quantity) - COALESCE(c.total_discount,0)) AS "daily_sales"
-- FROM orders o
-- LEFT JOIN(
--     SELECT
--         user_id,
--         SUM(discount_amount) AS total_discount
--     FROM coopon
--     GROUP BY user_id
-- ) c ON o.user_id = c.user_id
-- WHERE o.order_status != 'cancelled'
-- GROUP BY order_date;


-- SELECT
--     order_date,
--     SUM(
--         CASE 
--             WHEN stock_qty <= 0 THEN 0
--             WHEN stock_qty < quantity THEN stock_qty
--             ELSE quantity
--         END
--     ) AS total_ship_qty
-- FROM orders
-- WHERE order_status != 'cancelled'
-- GROUP BY order_date;


-- SELECT
--     order_date,
--     user_id,
--     quantity,
--     -- 商品ごとに、日付とユーザー順で累計を出す
--     SUM(quantity) OVER (ORDER BY order_date,user_id) AS cumulative_qty,
--     CASE 
--         -- 条件1:自分の順番が来た時に、すでに在庫がない場合
--         -- ①ORDER BY order_date,user_id:注文日(order_date)が古い順に並べて、同じ日ならユーザーID(user_id)が小さい順に並べる
--         -- ②OVER:①の結果を一番上の行から自分の行までの累計を計算する
--         WHEN stock_qty - (SUM(quantity) OVER (ORDER BY order_date,user_id) - quantity) <= 0 THEN 0
--         -- 条件2:自分の注文を引いても、在庫がまだ残る場合
--         WHEN stock_qty - (SUM(quantity) OVER (ORDER BY order_date,user_id) - quantity) >= quantity THEN quantity
--         -- 条件3:在庫はあるけど、注文分全ては足りない
--         -- ①PARTITION BY:在庫を商品ごとに別々に計算して
--         -- ②ORDER BY order_date,user_id:注文日(order_date)が古い順に並べて、同じ日ならユーザーID(user_id)が小さい順に並べる
--         -- ③OVER:①の結果を一番上の行から自分の行までの累計を計算する
--         ELSE stock_qty - (SUM(quantity) OVER (PARTITION BY product_id ORDER BY order_date,user_id) - quantity) 
--     END AS ship_qty
-- FROM orders
-- WHERE order_status != 'cancelled'

SELECT
    order_date,
    user_id,
    product_id,
    quantity,
    -- 商品ごとに、日付とユーザー順で累計を出す
    SUM(quantity) OVER (PARTITION BY product_id ORDER BY order_date,user_id) AS cumulative_qty,
    CASE 
        -- 条件1:自分の順番が来た時に、すでに在庫がない場合
        -- ⓪PARTITION BY:在庫を商品ごとに別々に計算して
        -- ①ORDER BY order_date,user_id:注文日(order_date)が古い順に並べて、同じ日ならユーザーID(user_id)が小さい順に並べる
        -- ②OVER:①の結果を一番上の行から自分の行までの累計を計算する
        WHEN stock_qty - (SUM(quantity) OVER (PARTITION BY product_id ORDER BY order_date,user_id) - quantity) <= 0 
        THEN 0
        -- 条件2:自分の注文を引いても、在庫がまだ残る場合
        WHEN stock_qty - (SUM(quantity) OVER (PARTITION BY product_id ORDER BY order_date,user_id) - quantity) >= quantity 
        THEN quantity
        -- 条件3:在庫はあるけど、注文分全ては足りない
        -- ①PARTITION BY:在庫を商品ごとに別々に計算して
        -- ②ORDER BY order_date,user_id:注文日(order_date)が古い順に並べて、同じ日ならユーザーID(user_id)が小さい順に並べる
        -- ③OVER:①の結果を一番上の行から自分の行までの累計を計算する
        ELSE stock_qty - (SUM(quantity) OVER (PARTITION BY product_id ORDER BY order_date,user_id) - quantity)
    END AS ship_qty
FROM orders
WHERE order_status != 'cancelled';

