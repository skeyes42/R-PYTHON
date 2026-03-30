import sqlite3
import pandas as pd
import os

# Connect
path_to_database = os.path.join(os.getenv("EXAMPLES"), "Boxscores.db")

# Context manager handles connection.
with sqlite3.connect(path_to_database) as con:
    # read_sql function executes SQL query
    query_text = "SELECT * FROM Boxscores"
    print(f"Executing query: {query_text}")

    results_df = pd.read_sql(query_text, con)

    print(results_df)
    print("Done")


