import sqlite3
import pandas as pd
import os
import sys

# Connect
path_to_database = os.getenv("EXAMPLES", "") + "Boxscores.db"
con = sqlite3.connect(path_to_database)

# Create cursor object
cursor = con.cursor()

# Check if the 'PTS' column exists in the 'Boxscores' table
table_name = "Boxscores"
column_to_check = "PTS"

# Use PRAGMA table_info to get column information
cursor.execute(f"PRAGMA table_info({table_name})")
columns_info = cursor.fetchall()
    
# Extract column names from the result
# info[1] is the column name
column_names = [info[1] for info in columns_info] 
    
if column_to_check not in column_names:
    print("Run ComputePercentagesPoints program again.")
    con.close()
    sys.exit(1) 
        
# Create scores by summarizing Boxscores
scores_df = pd.read_sql_query("""
    SELECT GAME_ID, TEAM_ID, SUM(PTS) AS SCORE
    FROM Boxscores GROUP BY GAME_ID, TEAM_ID""", con)

# Use a standard SQL query to perform the self-join and conditional logic.
query_sql = """
    WITH scores AS (
        SELECT GAME_ID, TEAM_ID, SUM(PTS) AS SCORE
        FROM Boxscores
        GROUP BY GAME_ID, TEAM_ID
    )
    SELECT
        t1.GAME_ID,
        t1.TEAM_ID AS TEAM_ID,
        t1.SCORE AS SCORE,
        CASE
            WHEN t1.SCORE > t2.SCORE THEN 1
            WHEN t1.SCORE < t2.SCORE THEN 0
            ELSE NULL
        END AS WIN_LOSS
    FROM scores AS t1
    LEFT JOIN scores AS t2
        ON t1.GAME_ID = t2.GAME_ID
    WHERE t1.TEAM_ID != t2.TEAM_ID;
"""

# Execute the query 
results_df = pd.read_sql_query(query_sql, con)

# Join results back to original boxscores and write to database
boxscores_df = pd.read_sql_query("SELECT * FROM Boxscores", con)

# Drop existing 'SCORE' and 'WIN_LOSS' columns 
columns_to_drop = ['SCORE', 'WIN_LOSS']
for col in columns_to_drop:
    if col in boxscores_df.columns:
        boxscores_df = boxscores_df.drop(columns=col)

# Perform the left join using pandas
# The 'SCORE' and 'WIN_LOSS' columns from results_df will be added to the 
# boxscores_df
joined_df = pd.merge(boxscores_df, results_df, 
                     on=['GAME_ID', 'TEAM_ID'], how='left')

# Write new data back into the Boxscores table, overwriting it
joined_df.to_sql(name='Boxscores', con=con, if_exists='replace', index=False)

# Disconnect database connection
con.close()

print(joined_df)