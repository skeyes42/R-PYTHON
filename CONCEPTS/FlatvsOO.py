from dataclasses import dataclass
from typing import List
import pandas as pd

# Your flat data
df = pd.DataFrame({
    'GAME_ID': [1000, 1000, 1000, 1000, 2000, 2000, 2000, 2000],
    'TEAM_ID': [100, 100, 200, 200, 100, 100, 300, 300],
    'PLAYER_ID': [1, 2, 3, 4, 1, 2, 5, 6],
    'FGM': [10, 4, 2, 8, 10, 11, 8, 7],
    'FG3M': [12, 4, 6, 2, 4, 5, 10, 6],
    'FTM': [12, 7, 5, 7, 10, 4, 9, 3]
})

@dataclass
class Player:
    player_id: int
    fgm: int
    fg3m: int
    ftm: int

@dataclass
class Game:
    game_id: int
    players: List[Player]

@dataclass
class Season:
    games: List[Game]

# Transform flat data to hierarchical structure
def build_season(df):
    games_list = []
    
    for gid in df['GAME_ID'].unique():
        game_data = df[df['GAME_ID'] == gid]
        
        players_list = []
        for _, row in game_data.iterrows():
            p = Player(
                player_id=int(row['PLAYER_ID']),
                fgm=int(row['FGM']),
                fg3m=int(row['FG3M']),
                ftm=int(row['FTM'])
            )
        players_list.append(p)
        
        games_list.append(Game(game_id=int(gid), players=players_list))
    
    return Season(games=games_list)

season = build_season(df)

# hierarchical access
print("=== Flat/Relational Access ===")
flat_result = df[(df['GAME_ID'] == 1000) & (df['PLAYER_ID'] == 1)]['FGM'].values[0]
print(f"Player 1's FGM in game 1000: {flat_result}\n")

print("=== Hierarchical/OO Access ===")
print(f"Player 1's FGM in game 1000: {season.games[0].players[0].fgm}\n")

# show structure
print("=== Season Structure ===")
print(f"Number of games: {len(season.games)}")
print(f"Players in game 1: {len(season.games[0].players)}")
print(f"Players in game 2: {len(season.games[1].players)}")