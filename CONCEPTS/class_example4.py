import pandas as pd
from dataclasses import dataclass
from typing import List, Optional
import io

# === BASE CLASS ===
@dataclass
class StatLine:
    FGM: int
    FGA: int
    FG3M: int
    FG3A: int
    FTM: int
    FTA: int

    def poly_print(self):
        print("From parent class")

    @property
    def fg_pct(self) -> Optional[float]:
        if self.FGA == 0: return None
        return round(self.FGM / self.FGA, 3)

    @property
    def fg3_pct(self) -> Optional[float]:
        if self.FG3A == 0: return None
        return round(self.FG3M / self.FG3A, 3)

    @property
    def ft_pct(self) -> Optional[float]:
        if self.FTA == 0: return None
        return round(self.FTM / self.FTA, 3)

    @property
    def points(self) -> int:
        return (self.FGM - self.FG3M) * 2 + self.FG3M * 3 + self.FTM



# === CHILD CLASS ===
@dataclass
class PlayerGame(StatLine):
    GAME_ID: int
    TEAM_ID: int
    PLAYER_ID: int

    # Overriding method for polymorphism
    def poly_print(self):
        print("From child class")

# === CONSTRUCTOR FROM DATA ===
def player_games_from_df(df: pd.DataFrame) -> List[PlayerGame]:
    # Equivalent to select() |> mutate(as.integer) |> pmap()
    cols = ['GAME_ID', 'TEAM_ID', 'PLAYER_ID', 'FGM', 'FGA', 'FG3M', 'FG3A', 'FTM', 'FTA']
    df_subset = df[cols].astype(int)
    
    # Create objects using dictionary unpacking
    return [PlayerGame(**row) for row in df_subset.to_dict('records')]

# === DEMO ===
csv_text = """GAME_ID,TEAM_ID,PLAYER_ID,FGM,FGA,FG3M,FG3A,FTM,FTA
1000,100,1,10,13,12,13,12,12
1000,100,2,4,16,4,8,7,8
1000,200,3,2,20,6,13,5,12
1000,200,4,8,16,2,8,7,8
2000,100,1,10,21,4,13,10,12
2000,100,2,11,16,5,8,4,8
2000,300,5,8,14,10,13,9,12
2000,300,6,7,16,6,8,3,8
3000,200,3,5,13,7,13,9,12
3000,200,4,3,17,2,8,6,8
3000,300,5,4,8,4,13,11,12
3000,300,6,8,16,3,8,3,8"""

# Test polymorphism
stat1 = StatLine(FGM=10, FGA=20, FG3M=3, FG3A=8, FTM=5, FTA=6)
pg1 = PlayerGame(GAME_ID=1000, TEAM_ID=100, PLAYER_ID=1, 
                 FGM=10, FGA=13, FG3M=12, FG3A=13, FTM=12, FTA=12)

print('---------- Test polymorphism ----------------')
stat1.poly_print()
pg1.poly_print()
print('---------------------------------------------')

# Load and build objects
df = pd.read_csv(io.StringIO(csv_text))
all_games = player_games_from_df(df)

# Inheritance Demo
print("\n=== INHERITANCE DEMO ===\n")
game1 = all_games[0]
print(f"Player {game1.PLAYER_ID}, Game {game1.GAME_ID}:")
print(f"  Points: {game1.points} | FG%: {game1.fg_pct*100:.1f}% | 3P%: {game1.fg3_pct*100:.1f}%\n")

# Class Verification
print("=== CLASS VERIFICATION ===")

cls = type(game1)
parent = cls.__mro__[1]

print(f"game1 class: {cls.__name__} (parent: {parent.__name__})")