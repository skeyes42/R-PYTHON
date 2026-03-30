import os
import sys
import pandas as pd
from pyRserve import connect
from pyRserve.taggedContainers import TaggedList

def get_boxscores_via_rserve():
    
    examples_dir = os.getenv("EXAMPLES")

    db_path = os.path.join(examples_dir, "Boxscores.db")
    r_class_path = os.path.join(examples_dir, "LIBRARY", "BoxscoresClass.R")
    r_class_path = r_class_path.replace("\\", "/")

    # --- Connect to Rserve ---
    print("Connecting to Rserve...")
    try:
        conn = connect(host="localhost", port=6311)
        print("Connected successfully")
    except ConnectionRefusedError:
        print("Error: Could not connect to Rserve")
        print("Make sure Rserve is running:")
        print("  library(Rserve)")
        print("  Rserve(args='--no-save')")
        return None

    # Send DB path into R
    conn.r.db_path = db_path

    # Load R class
    print(f"Loading R class from {r_class_path}")
    conn.eval(f'source("{r_class_path}")')

    # Call R function
    print("Retrieving Boxscores data...")
    result_df = conn.eval("get_Boxscores_data()")

    print(f"Retrieved {len(result_df)} rows")

    # A TaggedList was returned from R server. Convert to dataframe
    data = {}
    for i in range(len(result_df.keys)):
        col_name = result_df.keys[i]
        col_data = result_df.values[i]
        data[col_name] = col_data
        
    df = pd.DataFrame(data)
    
    conn.close()

    return df

def main():
    print(sys.executable)

    df = get_boxscores_via_rserve()

    if df is None:
        print("Failed to retrieve data")
        return

    # --- DataFrame summary ---
    print("\n--- DataFrame Info ---")
    print(f"Shape: {df.shape}")
    print(f"Columns: {list(df.columns)}")

    print("\n--- First Few Rows ---")
    print(df.head())

    print("\n--- Summary Statistics ---")
    numeric_cols = ["FGM", "FG3M", "FTM"]
    print(df[numeric_cols].describe())

    # Example: filter high scorers
    high_scorers = df[df["FGM"] > 8]
    print("\n--- High Scoring Performances (FGM > 8) ---")
    print(high_scorers[["GAME_ID", "PLAYER_NAME", "TEAM_NAME", "FGM"]])

    print("\nDone")


if __name__ == "__main__":
    main()