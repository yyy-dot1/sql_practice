import sqlite3
import pandas as pd
import logging
import os

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)

logger = logging.getLogger(__name__)

def execute_sql_file(filename,connection):
    if not os.path.exists(filename):
        logger.error(f"ファイルが見つかりません:{filename}")
        raise FileNotFoundError(f"Missing:{filename}")
    logger.info(f"SQL実行中")
    with open(filename,'r',encoding='utf-8') as f:
        sql = f.read()
    connection.executescript(sql)

def get_query_result(filename,connection):
    if not os.path.exists(filename):
        logger.error(f"ファイルが見つかりません:{filename}")
        raise FileNotFoundError(f"Missing:{filename}")
    logger.info(f"クエリ読み込み中:{filename}")
    with open(filename,'r',encoding='utf-8') as f:
        sql = f.read()
    return pd.read_sql_query(sql,connection)

#メイン処理
conn = sqlite3.connect(':memory:')

try:
    execute_sql_file('setup.sql',conn)
    logger.info("DB処理開始")

    execute_sql_file('seed.sql',conn)

    df = get_query_result('main.sql',conn)
    logger.info("DB処理終了")

    print("実行結果")
    print(df)

except Exception as e:
    print(f"エラーが発生しました")
finally:
    conn.close()

