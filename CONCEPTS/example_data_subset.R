# Define dataframe using literal vectors

df <- data.frame(
  GAME_ID = c(1000, 1000, 1000, 1000, 2000, 2000, 2000, 2000),
  TEAM_ID = c(100, 100, 200, 200, 100, 100, 300, 300),
  PLAYER_ID = c(1, 2, 3, 4, 1, 2, 5, 6),
  FGM = c(10, 4, 2, 8, 10, 11, 8, 7),
  FG3M = c(12, 4, 6, 2, 4, 5, 10, 6),
  FTM = c(12, 7, 5, 7, 10, 4, 9, 3)
)

# Display the dataframe
print(df)

# Different subset: boxscores has TEAM_ID = 400 which is not found in PLAYERs table
# Different subset: PLAYER has extra player not found in PLAYERs table

# Add a player with no boxscore data
players_df <- data.frame(
  PLAYER_ID = c(1, 2, 3, 4, 5, 6, 7),  # Added player 7
  PLAYER_NAME = c("Fred", "John", "Trevor", "Alex", "Jim", "Steve", "Michael")
)

# Add a boxscore with no player data
boxscores_df <- rbind(boxscores_df, 
                      data.frame(GAME_ID = 3000, TEAM_ID = 400, PLAYER_ID = 99, 
                                 FGM = 15, FG3M = 3, FTM = 8))