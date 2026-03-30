library(RSQLite)
library(DBI)
library(S7)
library(dplyr)


Teams <- new_class(
  "Teams",
  properties = list(
    path = new_property(class_character)
  ),
  # Custom constructor to set the path property
  constructor = function(path_to_database = character()) {
    new_object(S7_object(), path = path_to_database)
  }
)

# Create a new generic function for retrieving the data frame
teams_dataframe <- new_generic("teams_dataframe", "x")

method(teams_dataframe, Teams) <- function(x) {

  con <- dbConnect(RSQLite::SQLite(), x@path)
  
  query <- tbl(con, "Teams")
    
  results_df <- query |>
    collect()
    
  dbDisconnect(con)
    
    return(results_df)
}

get_Teams_instance <- function(db_path) {
  Teams(path_to_database = db_path)
}
