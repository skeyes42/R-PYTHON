library(tidyverse)

df <- tribble(
  ~GAME_ID, ~TEAM_ID, ~PLAYER_ID, ~FGM, ~FG3M, ~FTM,
      1000,      100,          1,   10,    12,   12,
      1000,      100,          2,    4,     4,    7,
      1000,      200,          3,    2,     6,    5,
      1000,      200,          4,    8,     2,    7,
      2000,      100,          1,   10,     4,   10,
      2000,      100,          2,   11,     5,    4,
      2000,      300,          5,    8,    10,    9,
      2000,      300,          6,    7,     6,    3
)

peek <- function(df) {
  print(df)
  return(df)
}

df |>
  mutate(TOTAL_PTS = 2*FGM + 3*FG3M + FTM) |>
    group_by(GAME_ID, TEAM_ID) |>
      summarise(TEAM_PTS = sum(TOTAL_PTS), .groups = "drop") |>
        arrange(GAME_ID, desc(TEAM_PTS)) |>
          peek()