library(RSQLite)
library(DBI)
library(S7)
library(dplyr)

Players <- new_class(
  "Players",
  properties = list(
    path = new_property(class_character)
  ),
  # Custom constructor to set the path property
  constructor = function(path_to_database = character()) {
    new_object(S7_object(), path = path_to_database)
  }
)

# Create a new generic function for retrieving the data frame
players_dataframe <- new_generic("players_dataframe", "x")

method(players_dataframe, Players) <- function(x) {

  con <- dbConnect(RSQLite::SQLite(), x@path)
  
  query <- tbl(con, "Players")
    
  results_df <- query |>
    collect()
    
  dbDisconnect(con)
    
    return(results_df)
}

get_Players_instance <- function(db_path) {
  Players(path_to_database = db_path)
}
