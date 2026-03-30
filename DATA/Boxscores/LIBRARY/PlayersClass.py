import sqlite3
import pandas as pd

class Players:
  
    path: str
    
    # Add an __init__ method to accept the 'path' argument
    def __init__(self, path: str):
        self.path = path
    
    def players_dataframe(self) -> pd.DataFrame:
       
        # Connect to the database
        con = sqlite3.connect(self.path)
        
        try:
            # Query the Players table
            query = "SELECT * FROM Players"
            results_df = pd.read_sql_query(query, con)
            
        finally:
            # Always close the connection
            con.close()
        
        return results_df


def get_Players_instance(db_path: str) -> Players:
   
    return Players(path=db_path)

