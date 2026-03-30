import sqlite3
import os
from dataclasses import dataclass, field
from typing import List
import pandas as pd

@dataclass
class Player:
    player_id: int
    fgm: int
    fga: int
    fg3m: int
    fg3a: int
    ftm: int
    fta: int


@dataclass
class Team:
    team_id: int
    players: List[Player] = field(default_factory=list)


@dataclass
class Game:
    game_id: int
    teams: List[Team] = field(default_factory=list)


@dataclass
class Season2025:
    season_id: int
    games: List[Game] = field(default_factory=list)


def load_season_from_db(db_path: str) -> dict:
    # Connect 
    con = sqlite3.connect(db_path)
    
    # Load all tables
    boxscores = pd.read_sql_query("SELECT * FROM Boxscores", con)
    teams_table = pd.read_sql_query("SELECT * FROM Teams", con)
    players_table = pd.read_sql_query("SELECT * FROM Players", con)
    season_table = pd.read_sql_query("SELECT * FROM Season2025", con)
    
    con.close()
    
    # Get unique game IDs
    game_ids = boxscores['GAME_ID'].unique()
    
    # Create list to store games
    games_list = []
    
    # Process each game
    for game_id in game_ids:
        # Get all boxscore entries for this game
        game_boxscores = boxscores[boxscores['GAME_ID'] == game_id]
        
        # Get unique team IDs in this game
        team_ids = game_boxscores['TEAM_ID'].unique()
        
        # Create list to store teams
        teams_list = []
        
        # Process each team
        for team_id in team_ids:
            # Get all players for this team in this game
            team_boxscores = (
                game_boxscores[game_boxscores['TEAM_ID'] == team_id])
            
            # Create list to store players
            players_list = []
            
            # Process each player
            for _, row in team_boxscores.iterrows():
                player = Player(
                    player_id=int(row['PLAYER_ID']),
                    fgm=int(row['FGM']),
                    fga=int(row['FGA']),
                    fg3m=int(row['FG3M']),
                    fg3a=int(row['FG3A']),
                    ftm=int(row['FTM']),
                    fta=int(row['FTA'])
                )
                players_list.append(player)
            
            # Create Team object
            team = Team(
                team_id=int(team_id),
                players=players_list
            )
            teams_list.append(team)
        
        # Create Game object
        game = Game(
            game_id=int(game_id),
            teams=teams_list
        )
        games_list.append(game)
    
    # Create Season2025 object
    season = Season2025(
        season_id=2025,
        games=games_list
    )
    
    # Return season object and the additional tables for reference
    return {
        'season': season,
        'teams_info': teams_table,
        'players_info': players_table,
        'season_stats': season_table
    }


def get_player_name(player_id: int, players_info: pd.DataFrame) -> str:
    player_mask = players_info['PLAYER_ID'] == player_id
    result = players_info[player_mask]['PLAYER_NAME']
    return result.iloc[0] if len(result) > 0 else None


def get_team_name(team_id: int, teams_info: pd.DataFrame) -> str:
    result = (
        teams_info[teams_info['TEAM_ID'] == team_id]['TEAM_NAME'])
    return result.iloc[0] if len(result) > 0 else None


def main():
    examples_dir = os.getenv("EXAMPLES", "")
    path_to_database = os.path.join(examples_dir, "Boxscores.db")
    
    # Load data
    data = load_season_from_db(path_to_database)
    
    season = data['season']
    teams_info = data['teams_info']
    players_info = data['players_info']
    season_stats = data['season_stats']
    
    # Access the first game
    first_game = season.games[0]
    print('--- First game ---')
    print(first_game)
    print()
    
    # Access the first team in the first game
    first_team = first_game.teams[0]
    print('--- First team ---')
    print(first_team)
    print()
    
    # Access players in that team
    first_player = first_team.players[0]
    print('--- First player ---')
    print(first_player)
    print()
    
    # Get player name
    player_name = get_player_name(first_player.player_id, players_info)
    print('--- Player name ---')
    print(player_name)
    print()
    
    # Get team name
    team_name = get_team_name(first_team.team_id, teams_info)
    print('--- Team name ---')
    print(team_name)
    print()


if __name__ == "__main__":
    main()