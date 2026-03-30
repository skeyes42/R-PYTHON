import os
import sqlite3
import pandas as pd
from io import StringIO

path_to_database = os.path.join(os.getenv("EXAMPLES", ""), "Boxscores.db")

with sqlite3.connect(path_to_database) as conn:
    
    # Create a dataframe of Players data from a CSV string.
    csv_players_data = (
        "PLAYER_ID,PLAYER_NAME\n"
        "1,Fred\n"
        "2,John\n"
        "3,Trevor\n"
        "4,Alex\n"
        "5,Jim\n"
        "6,Steve\n"
        "7,Herb"
    )

    players_data_df = pd.read_csv(StringIO(csv_players_data), 
                                 dtype={'PLAYER_ID': int, 
                                       'PLAYER_NAME': str})

    # Write the data frame to a database table.
    players_data_df.to_sql("Players", 
                          conn, 
                          if_exists="replace", 
                          index=False)

    # Reading it back into a DataFrame.
    results_df = pd.read_sql_query("SELECT * FROM Players", conn)

    print("Contents of the 'Players' table:")
    print(results_df)

print('Done')

