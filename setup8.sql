CREATE TABLE cats (
    cat_id INTEGER,
    cat_name TEXT,
    preferred_env TEXT -- '都会' か '田舎'
);

CREATE TABLE applicants (
    user_id INTEGER,
    prefecture TEXT, -- 都道府県名
    user_name TEXT
);