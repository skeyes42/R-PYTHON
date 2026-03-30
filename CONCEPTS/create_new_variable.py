import pandas as pd

boxscores_df = pd.DataFrame({
    'GAME_ID': [1000, 1000, 1000, 1000, 2000, 2000, 2000, 2000],
    'TEAM_ID': [100, 100, 200, 200, 100, 100, 300, 300],
    'PLAYER_ID': [1, 2, 3, 4, 1, 2, 5, 6],
    'FGM': [10, 4, 2, 8, 10, 11, 8, 7],
    'FG3M': [12, 4, 6, 2, 4, 5, 10, 6],
    'FTM': [12, 7, 5, 7, 10, 4, 9, 3]
})

# Adds new column while keeping all existing
boxscores_updated_df = boxscores_df.assign(
    SCORING_EFFORT=boxscores_df['FGM'] + boxscores_df['FG3M'] + boxscores_df['FTM']
)

print('---- Mutate (assign) --------------------')
print(boxscores_updated_df)
print()

# transmute equivalent - keeps only the new column
boxscores_updated_df = boxscores_df[[]].assign(
    SCORING_EFFORT=boxscores_df['FGM'] + boxscores_df['FG3M'] + boxscores_df['FTM']
)

print('---- Transmute --------------------')
print(boxscores_updated_df)
print()

# mutate across equivalent - apply function to multiple columns
cols_to_double = ['FGM', 'FG3M', 'FTM']
boxscores_updated_df = boxscores_df.assign(
    **{f"{col}_doubled": boxscores_df[col] * 2 for col in cols_to_double}
)

print('---- mutate across ----------------')
print(boxscores_updated_df)
print()