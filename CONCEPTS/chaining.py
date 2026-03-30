import pandas as pd

df = pd.DataFrame({
    'GAME_ID': [1000, 1000, 1000, 1000, 2000, 2000, 2000, 2000],
    'TEAM_ID': [100, 100, 200, 200, 100, 100, 300, 300],
    'PLAYER_ID': [1, 2, 3, 4, 1, 2, 5, 6],
    'FGM': [10, 4, 2, 8, 10, 11, 8, 7],
    'FG3M': [12, 4, 6, 2, 4, 5, 10, 6],
    'FTM': [12, 7, 5, 7, 10, 4, 9, 3]
})

# Compute total points for each scoring event
df['TOTAL_PTS'] = 2 * df['FGM'] + 3 * df['FG3M'] + df['FTM']

# Aggregate to team-level totals
team_totals = (
    df.groupby(['GAME_ID', 'TEAM_ID'], as_index=False)
      .agg(TEAM_PTS=('TOTAL_PTS', 'sum'))
)

# Sort within each game by descending team points
result = team_totals.sort_values(
    ['GAME_ID', 'TEAM_PTS'],
    ascending=[True, False]
)


print(result)