import pandas as pd

df = pd.DataFrame({
    'GAME_ID': [1000, 1000, 1000, 1000, 2000, 2000, 2000, 2000],
    'TEAM_ID': [100, 100, 200, 200, 100, 100, 300, 300],
    'PLAYER_ID': [1, 2, 3, 4, 1, 2, 5, 6],
    'FGM': [10, 4, 2, 8, 10, 11, 8, 7],
    'FG3M': [12, 4, 6, 2, 4, 5, 10, 6],
    'FTM': [12, 7, 5, 7, 10, 4, 9, 3]
})

print("Original data:")
print(df)

# Example 1: Overall summary statistics
overall_summary = df.agg(
    avg_fgm=('FGM', 'mean'),
    total_fgm=('FGM', 'sum')
)

print("\nOverall summary:")
print(overall_summary)

# Example 2: Summary by team
team_summary = df.groupby('TEAM_ID').agg(
    avg_fgm=('FGM', 'mean'),
    total_fgm=('FGM', 'sum')
).reset_index()

print("\nSummary by team:")
print(team_summary)

# Example 3: Summary by player
player_summary = df.groupby('PLAYER_ID').agg(
    total_fgm=('FGM', 'sum'),
    games_played=('FGM', 'size')
).reset_index()

print("\nSummary by player:")
print(player_summary)