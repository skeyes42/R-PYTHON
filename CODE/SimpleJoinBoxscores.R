library(RSQLite)
library(DBI)
library(dplyr)
library(readr)

path_to_database <- file.path(Sys.getenv("EXAMPLES"), "Boxscores.db")

# Connect
con <- dbConnect(RSQLite::SQLite(), path_to_database)

# Bring into Boxscores the player and team names
query <- tbl(con, "Boxscores")                    |>
  left_join(tbl(con, "Players"), by = "PLAYER_ID") |>
    left_join(tbl(con, "Teams"), by = "TEAM_ID")   |>
        arrange(GAME_ID, TEAM_ID) |>
          select(-PLAYER_ID, -TEAM_ID)

   
# Display the query
show_query(query) 

# Run the query
results_df <- query |>
  collect()

# Write back to database, replacing the old Boxscores table
dbWriteTable(con, "Boxscores", results_df, overwrite = TRUE)

# Disconnect database connection
dbDisconnect(con)

print(results_df, width = Inf)

