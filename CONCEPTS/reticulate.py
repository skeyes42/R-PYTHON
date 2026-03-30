import pandas as pd

def calculate_points(r_df):
    # Convert R dataframe to pandas
    df = pd.DataFrame(r_df)
    
    # Calculate points in Python
    df['PTS_PY'] = df['FGM'] * 2 + df['FG3M'] * 3 + df['FTM']
    
    print("\nPython processing:")
    print(df[['PLAYER_ID', 'FGM', 'FG3M', 'FTM', 'PTS_PY']])
    
    return df

# Create a Python-side variable accessible from R
df_python = pd.DataFrame({
    'message': ['Data processed in Python'],
    'status': ['complete']
})