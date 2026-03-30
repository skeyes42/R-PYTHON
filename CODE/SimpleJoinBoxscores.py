import sqlite3
import os
import pandas as pd

path_to_database = os.path.join(
    os.getenv("EXAMPLES"), "Boxscores.db")

# Connect
con = sqlite3.connect(path_to_database)

# Read tables into DataFrames
boxscores = pd.read_sql_query("SELECT * FROM Boxscores", con)
players = pd.read_sql_query("SELECT * FROM Players", con)
teams = pd.read_sql_query("SELECT * FROM Teams", con)

# Rename columns
players = players.rename(columns={'PLAYER_NAME': 'Player'})
teams = teams.rename(columns={'TEAM_NAME': 'Team'})

# Perform left joins

# Add player names
with_players = boxscores.merge(
    players[['PLAYER_ID', 'Player']],
    on='PLAYER_ID',
    how='left'
)

# Add team names
with_teams = with_players.merge(
    teams[['TEAM_ID', 'Team']],
    on='TEAM_ID',
    how='left'
)

# Final ordering and cleanup
results_df = (
    with_teams
        .sort_values(['GAME_ID', 'TEAM_ID'])
        .drop(columns=['PLAYER_ID', 'TEAM_ID'])
)

con.close()

print(results_df)