import os
import sqlite3
import pandas as pd
import numpy as np

db_path = os.path.join(os.getenv("EXAMPLES", ""), "Boxscores.db")

con = sqlite3.connect(db_path)

# Load source table
df = pd.read_sql_query("SELECT * FROM Boxscores", con)

# Set numeric types for percentage calculations
numeric_cols = ["FGM", "FGA", "FG3M", "FG3A", "FTM", "FTA"]
df[numeric_cols] = df[numeric_cols].astype(float)

# Field‑goal percentages
df["FG_PCT"] = np.where(df["FGA"] > 0, (df["FGM"] / df["FGA"]) * 100, 0)
df["FG3_PCT"] = np.where(df["FG3A"] > 0, (df["FG3M"] / df["FG3A"]) * 100, 0)
df["FT_PCT"] = np.where(df["FTA"] > 0, (df["FTM"] / df["FTA"]) * 100, 0)

# Point breakdown
fg2 = (df["FGM"] - df["FG3M"]) * 2
fg3 = df["FG3M"] * 3
ft = df["FTM"]

df["PTS"] = fg2 + fg3 + ft

df = df.sort_values(["GAME_ID", "TEAM_ID"])

# Replace table with updated results
df.to_sql("Boxscores", con, if_exists="replace", index=False)

con.close()

print(df.head())