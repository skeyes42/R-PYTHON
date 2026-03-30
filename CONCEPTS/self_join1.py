import pandas as pd

# Create the sample data
boxscores = pd.DataFrame({
    'GAME_ID': [1000, 1000, 1000, 1000, 2000, 2000, 2000, 2000, 3000, 3000, 3000, 3000],
    'TEAM_ID': [100, 100, 200, 200, 100, 100, 300, 300, 200, 200, 300, 300],
    'PLAYER_ID': [1, 2, 3, 4, 1, 2, 5, 6, 3, 4, 5, 6],
    'FGM': [10, 4, 2, 8, 10, 11, 8, 7, 5, 3, 4, 8],
    'FGA': [13, 16, 20, 16, 21, 16, 14, 16, 13, 17, 8, 16],
    'FG3M': [12, 4, 6, 2, 4, 5, 10, 6, 7, 2, 4, 3],
    'FG3A': [13, 8, 13, 8, 13, 8, 13, 8, 13, 8, 13, 8],
    'FTM': [12, 7, 5, 7, 10, 4, 9, 3, 9, 6, 11, 3],
    'FTA': [12, 8, 12, 8, 12, 8, 12, 8, 12, 8, 12, 8]
})

print("Original Boxscore Data:")
print(boxscores)

# Join the table to itself on GAME_ID and TEAM_ID
# This pairs each player with their teammate(s) in the same game
teammate_pairs = boxscores.merge(
    boxscores,
    on=['GAME_ID', 'TEAM_ID'],
    suffixes=('_p1', '_p2')
)

# Split into the two logical halves
key_cols = ['GAME_ID', 'TEAM_ID']
p1_cols = key_cols + [c for c in teammate_pairs.columns if c.endswith('_p1')]
p2_cols = key_cols + [c for c in teammate_pairs.columns if c.endswith('_p2')]

print(p1_cols)
print(p2_cols)

df_p1 = teammate_pairs[p1_cols]
df_p2 = teammate_pairs[p2_cols]

print(df_p1)
print(df_p2)

print(df_p1.to_markdown())




# Avoid pairing a player with themselves
teammate_pairs = teammate_pairs[
    teammate_pairs['PLAYER_ID_p1'] < teammate_pairs['PLAYER_ID_p2']
]

print("\n\nTeammate Pairs (via self-join):")
print(teammate_pairs[['GAME_ID', 'TEAM_ID', 'PLAYER_ID_p1', 'PLAYER_ID_p2',
                      'FGM_p1', 'FGM_p2', 'FG3M_p1', 'FG3M_p2']])

print(teammate_pairs.to_markdown(index = False))

# Calculate how much each pair's scoring differed in a game
teammate_analysis = teammate_pairs.copy()

# Total points (simplified: 2*FGM + FG3M + FTM)
teammate_analysis['PTS_p1'] = (2 * teammate_analysis['FGM_p1'] + 
                               teammate_analysis['FG3M_p1'] + 
                               teammate_analysis['FTM_p1'])
teammate_analysis['PTS_p2'] = (2 * teammate_analysis['FGM_p2'] + 
                               teammate_analysis['FG3M_p2'] + 
                               teammate_analysis['FTM_p2'])
teammate_analysis['PTS_diff'] = abs(teammate_analysis['PTS_p1'] - 
                                    teammate_analysis['PTS_p2'])
teammate_analysis['higher_scorer'] = teammate_analysis.apply(
    lambda row: row['PLAYER_ID_p1'] if row['PTS_p1'] > row['PTS_p2'] 
                else row['PLAYER_ID_p2'],
    axis=1
)

print("\n\nTeammate Scoring Comparison:")
print(teammate_analysis[['GAME_ID', 'TEAM_ID', 'PLAYER_ID_p1', 'PLAYER_ID_p2',
                         'PTS_p1', 'PTS_p2', 'PTS_diff', 'higher_scorer']])

# Shows which teams have balanced vs. star-dependent scoring
team_balance = (teammate_analysis
    .groupby('TEAM_ID')
    .agg(
        games_played=('GAME_ID', 'nunique'),
        avg_teammate_gap=('PTS_diff', 'mean'),
        max_teammate_gap=('PTS_diff', 'max')
    )
    .reset_index()
    .sort_values('avg_teammate_gap')
)

print("\n\nTeam Scoring Balance (lower gap = more balanced):")
print(team_balance)