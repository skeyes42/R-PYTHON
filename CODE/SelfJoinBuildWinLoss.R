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
       "Please run ComputePercentagesPoints program again.", 
    call. = FALSE)
}

# Create scores by summarizing Boxscores
scores <- tbl(con, "Boxscores") |>
  group_by(GAME_ID, TEAM_ID) |>
  summarise(
    SCORE = sum(PTS),
    .groups = "drop"
  )

# Left join scores with itself
query <- scores |>
      left_join(scores, 
                by = "GAME_ID", 
                suffix = c("_team","_opponent"), 
                relationship = "many-to-many")   |>
        filter(TEAM_ID_team != TEAM_ID_opponent) |>
          mutate(
                WIN_LOSS_team = case_when(
                  SCORE_team > SCORE_opponent ~ 1,
                  SCORE_team < SCORE_opponent ~ 0
                )
                ) |>
            mutate(
                    WIN_LOSS_opponent = case_when(
                      SCORE_opponent > SCORE_team ~ 1,
                      SCORE_opponent < SCORE_team ~ 0
                    )
                  ) |>
              select(-ends_with("_opponent")) |>
                rename_with(~ str_remove(., "_team"), ends_with("_team")) 

# Display the query
show_query(query) 

# Run the query
results_df <- query |>
  collect()

boxscores_df <- tbl(con, "Boxscores") |> collect()

joined_df <- left_join(boxscores_df, results_df, by = c("GAME_ID", "TEAM_ID")) 

print(joined_df, width = Inf)

# Put the new data back into the database: overwrite the Boxscores table
dbWriteTable(
  con,
  name = "Boxscores",
  value = joined_df,
  overwrite = TRUE
)

dbDisconnect(con)


