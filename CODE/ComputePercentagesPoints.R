library(RSQLite)
library(DBI)
library(dplyr)
library(readr)

path_to_database <- file.path(Sys.getenv("EXAMPLES"), "Boxscores.db")
con <- dbConnect(RSQLite::SQLite(), path_to_database)

# Build the query
query <- tbl(con, "Boxscores") |>
  mutate(
          FGM = as.double(FGM),   FGA = as.double(FGA),
          FG3M = as.double(FG3M), FG3A = as.double(FG3A),
          FTM = as.double(FTM),   FTA = as.double(FTA)
        ) |>
    mutate(

        # Create the percentage columns as before
        FG_PCT = case_when(FGA == 0 ~ 0, TRUE ~ (FGM / FGA) * 100),
        FG3_PCT = case_when(FG3A == 0 ~ 0, TRUE ~ (FG3M / FG3A) * 100),
        FT_PCT = case_when(FTA == 0 ~ 0, TRUE ~ (FTM / FTA) * 100),

        # Calculate points from two-pointers
        FG2_PTS = (FGM - FG3M) * 2,

        # Calculate points from three-pointers
        FG3_PTS = FG3M * 3,

        # Calculate points from free throws
        FT_PTS = FTM * 1,

        # Sum all the different types of points for the total score
        PTS = FG2_PTS + FG3_PTS + FT_PTS
      ) |>
        arrange(GAME_ID, TEAM_ID) |>
          select( -FG2_PTS, -FG3_PTS, -FT_PTS )
  
# Display the query
show_query(query) 

# Run the query
results_df <- query |>
  collect()

# Put the new data back into the database: overwrite the Boxscores table
dbWriteTable(
  con,
  name = "Boxscores",
  value = results_df,
  overwrite = TRUE
)

dbDisconnect(con)

print(results_df)