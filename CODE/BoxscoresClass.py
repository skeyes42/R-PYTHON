import sqlite3
import pandas as pd

class Boxscores:
  
    
    def __init__(self, path_to_database=""):
        
        self.path = path_to_database
    
    def boxscores_dataframe(self):
       
        # Connect to database
        con = sqlite3.connect(self.path)
        
        try:
            # Read tables
            boxscores = pd.read_sql_query("SELECT * FROM Boxscores", con)
            players = pd.read_sql_query("SELECT * FROM Players", con)
            teams = pd.read_sql_query("SELECT * FROM Teams", con)
            
            # Perform left joins
            results_df = boxscores.merge(players, on='PLAYER_ID', how='left')
            results_df = results_df.merge(teams, on='TEAM_ID', how='left')
            
            # Drop PLAYER_ID and TEAM_ID columns
            results_df = results_df.drop(columns=['PLAYER_ID', 'TEAM_ID'])
            
            return results_df
            
        finally:
            # Always close the connection
            con.close()


def get_boxscores_instance(db_path):

    return Boxscores(path_to_database=db_path)

