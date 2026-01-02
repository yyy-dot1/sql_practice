create table orders(
    user_id INTEGER,
    product_id INTEGER,
    order_date DATETIME,
    unit_price INTEGER,
    quantity INTEGER,
    order_status TEXT,
    stock_qty INTEGER
);

create table coopon(
    user_id INTEGER,
    discount_amount INTEGER
);