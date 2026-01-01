
-- 拡張した紹介候補者テーブル
CREATE TABLE IF NOT EXISTS candidates (
    candidate_id INTEGER PRIMARY KEY,
    candidate_name TEXT,
    -- 希望勤務地（都道府県）を3つまで
    preferred_pref_id_1 INTEGER,
    preferred_pref_id_2 INTEGER,
    preferred_pref_id_3 INTEGER,
    -- 希望地域を3つまで
    preferred_region_id_1 INTEGER,
    preferred_region_id_2 INTEGER,
    preferred_region_id_3 INTEGER,
    current_address_pref_id INTEGER,
    wants_remote
);

-- 案件情報テーブル
CREATE TABLE IF NOT EXISTS jobs (
    job_id INTEGER PRIMARY KEY,
    work_pref_id INTEGER, -- 勤務地の都道府県ID(1-47)
    status,
    salary
);

CREATE TABLE IF NOT EXISTS m_prefectures (
    pref_id INTEGER PRIMARY KEY,
    pref_name TEXT,
    region_id INTEGER,
    region_name TEXT
);

CREATE TABLE application_history(
    candidate_id INTEGER,
    job_id INTEGER,
    result TEXT
)
INSERT INTO m_prefectures (pref_id, pref_name, region_id, region_name) VALUES
(1, '北海道', 2, '東北・北海道'), (2, '青森県', 2, '東北・北海道'), (3, '岩手県', 2, '東北・北海道'), (4, '宮城県', 2, '東北・北海道'), (5, '秋田県', 2, '東北・北海道'), (6, '山形県', 2, '東北・北海道'), (7, '福島県', 2, '東北・北海道'),
(8, '茨城県', 3, '関東'), (9, '栃木県', 3, '関東'), (10, '群馬県', 3, '関東'), (11, '埼玉県', 3, '関東'), (12, '千葉県', 3, '関東'), (13, '東京都', 3, '関東'), (14, '神奈川県', 3, '関東'),
(15, '新潟県', 4, '中部'), (16, '富山県', 4, '中部'), (17, '石川県', 4, '中部'), (18, '福井県', 4, '中部'), (19, '山梨県', 4, '中部'), (20, '長野県', 4, '中部'), (21, '岐阜県', 4, '中部'), (22, '静岡県', 4, '中部'), (23, '愛知県', 4, '中部'),
(24, '三重県', 5, '関西'), (25, '滋賀県', 5, '関西'), (26, '京都府', 5, '関西'), (27, '大阪府', 5, '関西'), (28, '兵庫県', 5, '関西'), (29, '奈良県', 5, '関西'), (30, '和歌山県', 5, '関西'),
(31, '鳥取県', 6, '中国・四国'), (32, '島根県', 6, '中国・四国'), (33, '岡山県', 6, '中国・四国'), (34, '広島県', 6, '中国・四_国'), (35, '山口県', 6, '中国・四国'), (36, '徳島県', 6, '中国・四国'), (37, '香川県', 6, '中国・四国'), (38, '愛媛県', 6, '中国・四国'), (39, '高知県', 6, '中国・四国'),
(40, '福岡県', 7, '九州・沖縄'), (41, '佐賀県', 7, '九州・沖縄'), (42, '長崎県', 7, '九州・沖縄'), (43, '熊本県', 7, '九州・沖縄'), (44, '大分県', 7, '九州・沖縄'), (45, '宮崎県', 7, '九州・沖縄'), (46, '鹿児島県', 7, '九州・沖縄'), (47, '沖縄県', 7, '九州・沖縄');
