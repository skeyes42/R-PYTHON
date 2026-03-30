import pandas as pd
import sqlite3

class Teams:

    path: str
    
    def __init__(self, path_to_database: str = ""):
       
        self.path = path_to_database
    
    def teams_dataframe(self) -> pd.DataFrame:
      
        # Connect to database
        con = sqlite3.connect(self.path)
        
        try:
            # Query the Teams table
            query = "SELECT * FROM Teams"
            results_df = pd.read_sql_query(query, con)
            
            return results_df
        
        finally:
            # Always close the connection
            con.close()


def get_Teams_instance(db_path: str) -> Teams:
 
    return Teams(path_to_database=db_path)

