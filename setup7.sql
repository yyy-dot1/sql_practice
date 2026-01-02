-- create table visits(
--     user_id INTEGER,
--     entry_time DATETIME,
--     exit_time DATETIME,
--     stay_minutes TEXT
-- )

create table sales(
    visit_id INTEGER,
    cat_name TEXT,
    snack_price INTEGER
);

create table stocks(
    item_name TEXT,
    stock_qty INTEGER
);