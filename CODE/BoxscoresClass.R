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

get_Boxscores_data <- function() {
  path_to_database <- paste0(Sys.getenv("EXAMPLES"), "Boxscores.db")
  boxscores_object <- get_Boxscores_instance(db_path = path_to_database)
  boxscores_data   <-  boxscores_dataframe(boxscores_object)
  return(boxscores_data)
}
