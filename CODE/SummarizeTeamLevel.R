library(RSQLite)
library(DBI)
library(dplyr)
library(readr)
library(stringr)

# Connect
path_to_database <- file.path(Sys.getenv("EXAMPLES"), "Boxscores.db")
con <- dbConnect(RSQLite::SQLite(), path_to_database)

# Check if 'PTS' column exists in the 'Boxscores' table
if (!("PTS" %in% dbListFields(con, "Boxscores"))) {
  dbDisconnect(con)
  stop("Error: The 'PTS' variable is not present." + 
       "Please run ComputePercentagesPoints and " + 
       "SelfJoinBuildWinLoss programs again", 
    call. = FALSE)
}

query <- tbl(con, "Boxscores") |>
    group_by(TEAM_ID, GAME_ID) |>
    summarise(
      FG_PCT_AVG = mean(FG_PCT),
      FG3_PCT_AVG = mean(FG3_PCT),
      FT_PCT_AVG = mean(FT_PCT),
      GAME_WIN = max(WIN_LOSS),
      .groups = "drop"
    ) |>
      group_by(TEAM_ID) |>
      summarise(
        FG_PCT_AVG = mean(FG_PCT_AVG),
        FG3_PCT_AVG = mean(FG3_PCT_AVG),
        FT_PCT_AVG = mean(FT_PCT_AVG),
        SEASON_WINS = sum(GAME_WIN),
        .groups = "drop"
      ) |>
        left_join(tbl(con, "Teams"), join_by(TEAM_ID))

# Display the query
show_query(query) 

# Run the query
results_df <- query |>
  collect()

# Add a new table to Boxscores.db: Season
dbWriteTable(
  con,
  name = "Season2025",
  value = results_df,
  overwrite = TRUE
)

# Disconnect database connection
dbDisconnect(con)

print(results_df)

print("Done")