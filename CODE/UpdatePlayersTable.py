import os
import sqlite3
import pandas as pd

# Connect to a database
# Context manager handles connection
path_to_database = os.path.join(os.getenv("EXAMPLES", ""), "Boxscores.db")
with sqlite3.connect(path_to_database) as con:
    
    # Create a cursor object
    cur = con.cursor()
    
    # Construct the SQL UPDATE statement
    sql_update_query = (
        "UPDATE Players "
        "SET PLAYER_NAME = 'Johnie' "
        "WHERE PLAYER_ID = 2;"
    )
    
    # Execute the statement
    cur.execute(sql_update_query)
    
    # Commit the changes to the database
    con.commit()
    
    # Read table back and print 
    results_df = pd.read_sql_query("SELECT * FROM Players", con)
    print(results_df)

print("Done")
