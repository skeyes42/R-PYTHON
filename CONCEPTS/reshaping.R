library(tidyverse)
library(RSQLite)


dump <- function(x) {
  print(x)
  cat("\n")
  return(invisible(x))
}

# Connect to database with error handling
path_to_database <- file.path(Sys.getenv("EXAMPLES"), "Boxscores.db")
 
con <- dbConnect(RSQLite::SQLite(), path_to_database)

# Bring into Boxscores the player and team names
query <- tbl(con, "Boxscores")                     |>
  left_join(tbl(con, "Players"), by = "PLAYER_ID") |>
    left_join(tbl(con, "Teams"), by = "TEAM_ID")   |>
        arrange(GAME_ID, TEAM_ID)                  |>
          select(-PLAYER_ID, -TEAM_ID)             |>
            as_tibble() 
           

# Run the query
shooting <- query |>
  collect()

print(shooting)

dbDisconnect(con)

shooting_summary <- shooting |>

  pivot_longer(
    cols      = c(FGM, FGA, FG3M, FG3A, FTM, FTA),
    names_to  = "stat_type",
    values_to = "count"
  ) |> dump() |>

  mutate(
    shot_type    = str_remove(stat_type, "(M|A)$"),
    made_attempt = str_extract(stat_type, "(M|A)$")
  ) |> dump() |>

  select(-stat_type) |>

  pivot_wider(
    names_from  = made_attempt,
    values_from = count,
    values_fn   = sum
  ) |> dump() |>
  
  group_by(PLAYER_NAME, TEAM_NAME, shot_type) |>
  summarise(
    attempts = sum(A),
    pct      = sum(M) / sum(A) * 100,
    .groups  = "drop"
  )

print(shooting_summary)




