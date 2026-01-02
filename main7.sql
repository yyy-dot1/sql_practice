SELECT 
CASE
WHEN stay_minutes > 60
THEN (stay_minutes - 60) / 10 * 200 -- 延長料金
ELSE 0
FROM visits;