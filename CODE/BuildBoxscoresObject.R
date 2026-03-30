library(RSQLite)
library(DBI)
library(S7)
library(dplyr)

Boxscores <- new_class(
  "Boxscores",
  properties = list(
    path = new_property(class_character)
  ),
  constructor = function(path_to_database = character()) {
    new_object(S7_object(), path = path_to_database)
  }
)

# Create a new generic function for retrieving the data frame
boxscores_dataframe <- new_generic("Boxscores_dataframe", "x")

method(boxscores_dataframe, Boxscores) <- function(x) {

  con <- dbConnect(RSQLite::SQLite(), x@path)
  
  query <- tbl(con, "Boxscores") |>
      left_join(tbl(con, "Players"), by = "PLAYER_ID") |>
        left_join(tbl(con, "Teams"), by = "TEAM_ID") |>
          select(-PLAYER_ID, -TEAM_ID)
    
  results_df <- query |>
    collect()
    
  dbDisconnect(con)
    
  return(results_df)
}

get_Boxscores_instance <- function(db_path) {
  Boxscores(path_to_database = db_path)
}

path_to_database <- file.path(Sys.getenv("EXAMPLES"), "Boxscores.db")

# Instantiate the Boxscores class
boxscores_object <- get_Boxscores_instance(path_to_database)

# Call class method to get data
boxscores_data <- boxscores_dataframe(boxscores_object)

# Capture the output
options(width = 200)
sink("results.txt")
# View the resulting data frame
print(boxscores_data)
sink()

print('Done')