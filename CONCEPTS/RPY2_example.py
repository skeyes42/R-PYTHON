import pandas as pd
from rpy2.robjects import r
from rpy2.robjects import pandas2ri
from rpy2.robjects.conversion import localconverter

# Create the data in Python
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

import pandas as pd
import rpy2.robjects as ro
from rpy2.robjects import r, pandas2ri
from rpy2.robjects.conversion import localconverter

df['PTS_PY'] = df['FGM'] * 2 + df['FG3M'] * 3 + df['FTM']

print('Python calculation:')
print(df)

# Load the R script first
r.source('RPY2_example.R')

# Get the R function OUTSIDE the converter block
calculate_points_r = r['calculate_points']

# Use the converter ONLY when passing the data
with localconverter(pandas2ri.converter):
    result = calculate_points_r(df)

print("\nR calculation returned:")
print(result)

print(r.message_from_r)
