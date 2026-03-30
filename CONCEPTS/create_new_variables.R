library(dplyr)

boxscores_df <- data.frame(
  GAME_ID = c(1000, 1000, 1000, 1000, 2000, 2000, 2000, 2000),
  TEAM_ID = c(100, 100, 200, 200, 100, 100, 300, 300),
  PLAYER_ID = c(1, 2, 3, 4, 1, 2, 5, 6),
  FGM = c(10, 4, 2, 8, 10, 11, 8, 7),
  FG3M = c(12, 4, 6, 2, 4, 5, 10, 6),
  FTM = c(12, 7, 5, 7, 10, 4, 9, 3)
)

boxscores_updated_df <- boxscores_df |>
  mutate(SCORING_EFFORT = FGM + FG3M + FTM)

print('---- Mutate --------------------')
print(boxscores_updated_df)
cat('\n')

boxscores_updated_df <- boxscores_df |>
  transmute(SCORING_EFFORT = FGM + FG3M + FTM)

print('---- Transmute --------------------')
print(boxscores_updated_df)
cat('\n')

boxscores_updated_df <- boxscores_df |>
  mutate(across(c(FGM, FG3M, FTM), ~ .x * 2)) |>
  rename_with(~ paste0(.x, "_doubled"), c(FGM, FG3M, FTM))  

print('---- mutate across ----------------')
print(boxscores_updated_df)
cat('\n')

