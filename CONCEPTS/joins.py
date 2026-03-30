import pandas as pd

# Add a player with no boxscore data
players_df = pd.DataFrame({
    'PLAYER_ID': [1, 2, 3, 4, 5, 6, 7],  # Added player 7
    'PLAYER_NAME': ['Fred', 'John', 'Trevor', 'Alex', 'Jim', 'Steve', 'Michael']
})

boxscores_df = pd.DataFrame({
    'GAME_ID': [1000, 1000, 1000, 1000, 2000, 2000, 2000, 2000],
    'TEAM_ID': [100, 100, 200, 200, 100, 100, 300, 300],
    'PLAYER_ID': [1, 2, 3, 4, 1, 2, 5, 6],
    'FGM': [10, 4, 2, 8, 10, 11, 8, 7],
    'FG3M': [12, 4, 6, 2, 4, 5, 10, 6],
    'FTM': [12, 7, 5, 7, 10, 4, 9, 3]
})

# Add a boxscore with no player data
new_row = pd.DataFrame({
    'GAME_ID': [3000],
    'TEAM_ID': [400],
    'PLAYER_ID': [99],
    'FGM': [15],
    'FG3M': [3],
    'FTM': [8]
})
boxscores_df = pd.concat([boxscores_df, new_row], ignore_index=True)

#-----------------------------------------------------------    
# Inner join
result_df = pd.merge(boxscores_df, players_df, on='PLAYER_ID', how='inner')

print("\nInner join")
print(result_df)

#-----------------------------------------------------------    
# Left join
result_df = pd.merge(boxscores_df, players_df, on='PLAYER_ID', how='left')

print("\nLeft join")
print(result_df)

#----------------------------------------------------------- 
# Right join
result_df = pd.merge(boxscores_df, players_df, on='PLAYER_ID', how='right')

print("\nRight join")
print(result_df)

#----------------------------------------------------------- 
# Full join
result_df = pd.merge(boxscores_df, players_df, on='PLAYER_ID', how='outer')

print("\nFull join")
print(result_df)