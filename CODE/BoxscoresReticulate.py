import sqlite3
import pandas as pd
import os

def getBoxscores(dbname, table_name):

    with sqlite3.connect(dbname) as conn:
        query = f"SELECT * FROM {table_name}"
            
        # Read {table_name}
        df = pd.read_sql_query(query, conn)
            
    return(df)