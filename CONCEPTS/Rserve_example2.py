from pyRserve import connect
import pandas as pd

# Small boxscores dataset as CSV string
boxscores_data = """
GAME_ID,PLAYER_ID,FGM,FGA,FG3M,FG3A
1000,1,10,13,12,13
1000,2,4,16,4,8
2000,1,10,21,4,13
2000,2,11,16,5,8
"""

# Connect to Rserve (assumes it's running on localhost:6311)
try:
    conn = connect(host='localhost', port=6311)
    print("Connected to Rserve successfully")
    
    # Send the CSV data to R
    conn.r.boxscores_csv = boxscores_data
    
    # Execute R code to process the data
    # This reads the CSV string and computes mean FGM by player
    r_code = """
    library(dplyr)
    
    # Read CSV from the string
    df <- read.csv(text = boxscores_csv, stringsAsFactors = FALSE)
    
    # Calculate mean FGM by player
    result <- df %>%
        group_by(PLAYER_ID) %>%
        summarize(
            avg_FGM = mean(FGM),
            avg_FG3M = mean(FG3M)
        )
    
    result
    """
    # Execute the R code and get results
    result = conn.eval(r_code)

    # Convert R dataframe to pandas DataFrame
    # The result is a TaggedList - convert to proper DataFrame
    df = pd.DataFrame({
        'PLAYER_ID': list(result['PLAYER_ID']),
        'avg_FGM': list(result['avg_FGM']),
        'avg_FG3M': list(result['avg_FG3M'])
    })
    
    print("\nResults after conversion from R:")
    print(df)
    print(f"\nType: {type(df)}")
    
    # You can also execute simple R expressions
    total_games = conn.eval('length(unique(df$GAME_ID))')
    print(f"\nTotal unique games: {total_games}")
    
    # Close the connection
    conn.close()
    print("\nConnection closed")
    
except ConnectionRefusedError:
    print("Error: Could not connect to Rserve.")
    print("Make sure Rserve is running in R:")
    print("  library(Rserve)")
    print("  Rserve(args='--no-save')")
except Exception as e:
    print(f"Error: {e}")

