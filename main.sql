-- WITH matching_result AS (
--     SELECT
--         c.candidate_name,
--         j.job_id,
--         m.pref_name AS 勤務地,
--         m.region_name AS 勤務地域,
--         CASE 
--             -- 優先度1: 希望都道府県ID(1,2,3)のいずれかが案件の都道府県IDと一致
--             WHEN j.work_pref_id IN (c.preferred_pref_id_1, c.preferred_pref_id_2, c.preferred_pref_id_3)
--                 THEN '優先度1: 希望都道府県一致'
            
--             -- 優先度2: 都道府県希望がすべてNULL かつ 希望地域ID(1,2,3)のいずれかが案件の地域IDと一致
--             WHEN c.preferred_pref_id_1 IS NULL 
--                  AND c.preferred_pref_id_2 IS NULL 
--                  AND c.preferred_pref_id_3 IS NULL
--                  AND m.region_id IN (c.preferred_region_id_1, c.preferred_region_id_2, c.preferred_region_id_3)
--                 THEN '優先度2: 希望地域一致'
            
--             -- 優先度3: 希望が全てNULL かつ 現住所が一致
--             WHEN c.preferred_pref_id_1 IS NULL AND c.preferred_pref_id_2 IS NULL AND c.preferred_pref_id_3 IS NULL
--                  AND c.preferred_region_id_1 IS NULL AND c.preferred_region_id_2 IS NULL AND c.preferred_region_id_3 IS NULL
--                  AND c.current_address_pref_id = j.work_pref_id 
--                 THEN '優先度3: 現住所一致'
            
--             ELSE NULL 
--         END AS match_priority
--     FROM candidates c
--     CROSS JOIN jobs j
--     LEFT JOIN m_prefectures m ON j.work_pref_id = m.pref_id
-- )
-- SELECT * FROM matching_result 
-- WHERE match_priority IS NOT NULL
-- ORDER BY candidate_name, match_priority;

WITH priority_1_matchies AS(
    SELECT
        c.candidate_id,
        c.candidate_name,
        j.job_id,
        '優先度1: 希望都道府県一致' AS match_type,
        1 AS priority_score,
        j.status,
        salary,
        wants_remote
    FROM candidates c
    INNER JOIN jobs j ON j.work_pref_id IN (c.preferred_pref_id_1,c.preferred_pref_id_2,c.preferred_pref_id_3)
    WHERE status = 'active'
    AND (c.wants_remote = 0 OR (c.wants_remote = 1 AND j.is_remote = 1))
    -- 各マッチングのWHERE句に以下のようなイメージで追加します
    AND NOT EXISTS (
    SELECT 1 
    FROM application_history ah 
    WHERE ah.candidate_id = c.candidate_id 
      AND ah.job_id = j.job_id 
      AND ah.result = 'rejected'
)
),

priority_2_matchies AS(
    SELECT
        c.candidate_id,
        c.candidate_name,
        j.job_id,
        '優先度2: 現住所一致' AS match_type,
        2 AS priority_score,
        j.status,
        salary,
        wants_remote
    FROM candidates c
    INNER JOIN jobs j ON c.ccurrent_address_pref_id = j.work_pref_id
    WHERE
        status = 'active',
        AND (c.wants_remote = 0 OR (c.wants_remote = 1 AND j.is_remote = 1)),
        AND c.preferred_pref_id_1 IS NULL
        AND c.preferred_pref_id_2 IS NULL
        AND c.preferred_pref_id_3 IS NULL
        -- 各マッチングのWHERE句に以下のようなイメージで追加します
    AND NOT EXISTS (
    SELECT 1 
    FROM application_history ah 
    WHERE ah.candidate_id = c.candidate_id 
      AND ah.job_id = j.job_id 
      AND ah.result = 'rejected'
)
),

combined_results AS(
    SELECT * FROM priority_1_matchies
    UNION ALL
    SELECT * FROM priority_2_matchies
),

SELECT * FROM(
    *,
    ROW_NUMBER() OVER (
        PARTITION BY candidate_id   -- 候補者ごとにグループ化
        ORDER BY salary DESC, job_id ASC -- 給与が高い順、同額ならID順
    ) as ranking
FROM combined_results
) AS ranked
WHERE ranking = 1;