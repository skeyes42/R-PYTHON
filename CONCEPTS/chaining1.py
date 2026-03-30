import pandas as pd

df = pd.DataFrame([
    {'GAME_ID': 1000, 'TEAM_ID': 100, 'PLAYER_ID': 1, 'FGM': 10, 'FG3M': 12, 'FTM': 12},
    {'GAME_ID': 1000, 'TEAM_ID': 100, 'PLAYER_ID': 2, 'FGM':  4, 'FG3M':  4, 'FTM':  7},
    {'GAME_ID': 1000, 'TEAM_ID': 200, 'PLAYER_ID': 3, 'FGM':  2, 'FG3M':  6, 'FTM':  5},
    {'GAME_ID': 1000, 'TEAM_ID': 200, 'PLAYER_ID': 4, 'FGM':  8, 'FG3M':  2, 'FTM':  7},
    {'GAME_ID': 2000, 'TEAM_ID': 100, 'PLAYER_ID': 1, 'FGM': 10, 'FG3M':  4, 'FTM': 10},
    {'GAME_ID': 2000, 'TEAM_ID': 100, 'PLAYER_ID': 2, 'FGM': 11, 'FG3M':  5, 'FTM':  4},
    {'GAME_ID': 2000, 'TEAM_ID': 300, 'PLAYER_ID': 5, 'FGM':  8, 'FG3M': 10, 'FTM':  9},
    {'GAME_ID': 2000, 'TEAM_ID': 300, 'PLAYER_ID': 6, 'FGM':  7, 'FG3M':  6, 'FTM':  3},
])

def peek(data, message="Data:"):
    print(f"{message} {data}")
    return data

result = (
    df
    .assign(TOTAL_PTS = lambda x: 2*x['FGM'] + 3*x['FG3M'] + x['FTM'])
    .groupby(['GAME_ID', 'TEAM_ID'], as_index=False)
    .agg(TEAM_PTS=('TOTAL_PTS', 'sum'))
    .sort_values(['GAME_ID', 'TEAM_PTS'], ascending=[True, False])
    .pipe(peek, message= "Result")
    
)
