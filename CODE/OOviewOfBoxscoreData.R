library(DBI)
library(RSQLite)
library(S7)

Player <- new_class(
  name = "Player",
  properties = list(
    player_id = class_integer,
    fgm = class_integer,
    fga = class_integer,
    fg3m = class_integer,
    fg3a = class_integer,
    ftm = class_integer,
    fta = class_integer
  )
)

Team <- new_class(
  name = "Team",
  properties = list(
    team_id = class_integer,
    players = class_list
  )
)

Game <- new_class(
  name = "Game",
  properties = list(
    game_id = class_integer,
    teams = class_list
  )
)

Season2025 <- new_class(
  name = "Season2025",
  properties = list(
    season_id = class_integer,
    games = class_list
  )
)

# Function to load data from SQLite database and create Season2025 object
load_season_from_db <- function(db_path) {
  con <- dbConnect(SQLite(), db_path)
  
  # Load all tables
  boxscores <- dbReadTable(con, "Boxscores")
  teams_table <- dbReadTable(con, "Teams")
  players_table <- dbReadTable(con, "Players")
  season_table <- dbReadTable(con, "Season2025")
  
  # Close the connection
  dbDisconnect(con)
  
  # Get unique game IDs
  game_ids <- unique(boxscores$GAME_ID)
  
  # Create list to store games
  games_list <- list()
  
  # Process each game
  for (game_id in game_ids) {
    
    # Get all boxscore entries for this game
    game_boxscores <- boxscores[boxscores$GAME_ID == game_id, ]
    
    # Get unique team IDs in this game
    team_ids <- unique(game_boxscores$TEAM_ID)
    
    # Create list to store teams
    teams_list <- list()
    
    # Process each team
    for (team_id in team_ids) {
      # Get all players for this team in this game
      team_boxscores <- game_boxscores[game_boxscores$TEAM_ID == team_id, ]
      
      # Create list to store players
      players_list <- list()
      
      # Process each player
      for (i in 1:nrow(team_boxscores)) {
        player <- Player(
          player_id = as.integer(team_boxscores$PLAYER_ID[i]),
          fgm = as.integer(team_boxscores$FGM[i]),
          fga = as.integer(team_boxscores$FGA[i]),
          fg3m = as.integer(team_boxscores$FG3M[i]),
          fg3a = as.integer(team_boxscores$FG3A[i]),
          ftm = as.integer(team_boxscores$FTM[i]),
          fta = as.integer(team_boxscores$FTA[i])
        )
        players_list[[i]] <- player
      }
      
      # Create Team object
      team <- Team(
        team_id = as.integer(team_id),
        players = players_list
      )
      teams_list[[length(teams_list) + 1]] <- team
    }
    
    # Create Game object
    game <- Game(
      game_id = as.integer(game_id),
      teams = teams_list
    )
    games_list[[length(games_list) + 1]] <- game
  }
  
  # Create Season2025 object
  season <- Season2025(
    season_id = 2025L,
    games = games_list
  )
  
  # Return season object and the additional tables for reference
  return(list(
    season = season,
    teams_info = teams_table,
    players_info = players_table,
    season_stats = season_table
  ))
}

# Function to get player name from players_info
get_player_name <- function(player_id, players_info) {
  players_info$PLAYER_NAME[players_info$PLAYER_ID == player_id]
}

# Function to get team name from teams_info
get_team_name <- function(team_id, teams_info) {
  teams_info$TEAM_NAME[teams_info$TEAM_ID == team_id]
}

path_to_database <- file.path(Sys.getenv("EXAMPLES"), "Boxscores.db")
data <- load_season_from_db(path_to_database)

season <- data$season
teams_info <- data$teams_info
players_info <- data$players_info
season_stats <- data$season_stats

# Access the first game
first_game <- season@games[[1]]
print('--- First game ---')
print(first_game)
cat('\n')

# Access the first team in the first game
first_team <- first_game@teams[[1]]
print('--- First team ---')
print(first_team)
cat('\n')

# Access players in that team
first_player <- first_team@players[[1]]
print('--- First player ---')
print(first_player)
cat('\n')

# Get player name
player_name <- get_player_name(first_player@player_id, players_info)
print('--- Player name ---')
print(player_name)
cat('\n')

# Get team name
team_name <- get_team_name(first_team@team_id, teams_info)
print('--- Team name ---')
print(team_name)
cat('\n')
