library(dplyr)

df <- data.frame(
  GAME_ID = c(1000, 1000, 1000, 1000, 2000, 2000, 2000, 2000),
  TEAM_ID = c(100, 100, 200, 200, 100, 100, 300, 300),
  PLAYER_ID = c(1, 2, 3, 4, 1, 2, 5, 6),
  FGM = c(10, 4, 2, 8, 10, 11, 8, 7),
  FG3M = c(12, 4, 6, 2, 4, 5, 10, 6),
  FTM = c(12, 7, 5, 7, 10, 4, 9, 3)
)

print("Original data:")
print(df)

# Summary by TEAM_ID
team_summary <- df |>
  group_by(TEAM_ID) |>
  summarize(
    avg_fgm = mean(FGM),
    total_fgm = sum(FGM),
    n_players = n()
  )

print("Summary by team:")
print(team_summary)

# Summary by GAME_ID
game_summary <- df |>
  group_by(GAME_ID) |>
  summarize(
    avg_fgm = mean(FGM),
    total_fgm = sum(FGM)
  )

print("Summary by game:")
print(game_summary)

# Multiple grouping levels: GAME_ID and TEAM_ID
game_team_summary <- df |>
  group_by(GAME_ID, TEAM_ID) |>
  summarize(
    avg_fgm = mean(FGM),
    total_fgm = sum(FGM),
    .groups = "drop"
  )

print("Summary by game and team:")
print(game_team_summary)