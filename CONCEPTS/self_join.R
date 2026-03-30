library(dplyr)

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

# Self-join
df_self_join <- df |>
  left_join(
    df,
    by = "GAME_ID",
    suffix = c("", "x")
  ) |>
    print() |>
      select(everything())
      
 

