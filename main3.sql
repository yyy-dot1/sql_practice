
WITH user_activity AS (
    SELECT 
        u.user_id,
        COALESCE(l.login_date, p.purchase_date, u.signup_date) AS last_active_date
    FROM users u
    LEFT JOIN login_history l ON u.user_id = l.user_id
    LEFT JOIN purchase_history p ON u.user_id = p.user_id
)
SELECT 
    user_id,
    last_active_date,
    CAST(julianday('2026-01-01') - julianday(last_active_date) AS INTEGER) AS elapsed_days
FROM user_activity
WHERE elapsed_days >= 30;