-- SELECT
--     a.user_name,
--     a.prefecture,
--     c.cat_name,
--     CASE
--         WHEN a.prefecture IN('東京','大阪')
--             AND c.preferred_env = '都会' THEN '相性GOOD'
--         WHEN a.prefecture NOT IN('東京','大阪')
--             AND c.preferred_env = '田舎' THEN '相性GOOD'
--         ELSE '要相談'
--     END AS compatibility
-- FROM applicants a
-- CROSS JOIN cats c;

SELECT
    a.user_name,
    a.prefecture,
    c.cat_name,
    CASE
        WHEN (a.prefecture LIKE '東京%' OR a.prefecture LIKE '大阪%')
            AND c.preferred_env = '都会' THEN '相性GOOD'
        WHEN NOT(a.prefecture LIKE '東京%' OR a.prefecture LIKE '大阪%') 
            AND c.preferred_env = '田舎' THEN '相性GOOD'
        ELSE '要相談'
    END AS compatibility
FROM applicants a
CROSS JOIN cats c;