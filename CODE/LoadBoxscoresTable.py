import os
import pandas as pd
import sqlite3

# Define file paths
path_to_data = os.getenv("EXAMPLES")
path_to_database = os.path.join(path_to_data, "boxscores.db")
path_to_csv = os.path.join(path_to_data, "boxscores.csv")

# Connect to database
with sqlite3.connect(path_to_database) as db_connection:
    
    df_boxscores = pd.read_csv(path_to_csv)

    # Append the data from the DataFrame to the "Boxscores" table. 
    df_boxscores.to_sql("Boxscores", db_connection, if_exists='append', 
                        index=False)

print(df_boxscores.head())

print("Done")

