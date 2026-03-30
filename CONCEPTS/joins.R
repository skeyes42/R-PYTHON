library(dplyr)

# Add a player with no boxscore data
players_df <- data.frame(
  PLAYER_ID = c(1, 2, 3, 4, 5, 6, 7),  # Added player 7
  PLAYER_NAME = c("Fred", "John", "Trevor", "Alex", "Jim", "Steve", "Michael")
)

boxscores_df <- data.frame(
  GAME_ID = c(1000, 1000, 1000, 1000, 2000, 2000, 2000, 2000),
  TEAM_ID = c(100, 100, 200, 200, 100, 100, 300, 300),
  PLAYER_ID = c(1, 2, 3, 4, 1, 2, 5, 6),
  FGM = c(10, 4, 2, 8, 10, 11, 8, 7),
  FG3M = c(12, 4, 6, 2, 4, 5, 10, 6),
  FTM = c(12, 7, 5, 7, 10, 4, 9, 3)
)

# Add a boxscore with no player data
boxscores_df <- rbind(boxscores_df, 
                      data.frame(GAME_ID = 3000, TEAM_ID = 400, PLAYER_ID = 99, 
                                 FGM = 15, FG3M = 3, FTM = 8))

#-----------------------------------------------------------    
# Inner join                        )
result_df <- inner_join(boxscores_df, players_df, by = "PLAYER_ID")

cat("\n Inner join\n")
print(result_df)

#-----------------------------------------------------------    
# Left join

result_df <- left_join(boxscores_df, players_df, by = "PLAYER_ID")

cat("\n Left join\n")
print(result_df)

#----------------------------------------------------------- 
# Right join
result_df <- right_join(boxscores_df, players_df, by = "PLAYER_ID")

cat("\n Right join\n")
print(result_df)

#----------------------------------------------------------- 
# Full join                         )
result_df <- full_join(boxscores_df, players_df, by = "PLAYER_ID")

cat("\n Full join\n")
print(result_df)
