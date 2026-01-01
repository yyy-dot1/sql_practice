create table stock(
    warehouse_id INTEGER,
    product_id TEXT,
    quantity INTEGER
);

create table orders(
    order_id INTEGER,
    user_id TEXT,
    product_id TEXT,
    order_time TEXT,
    user_rank TEXT,
    order_qty INTEGER
);