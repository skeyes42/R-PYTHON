library(DBI)
library(RSQLite)
library(readr)

execute_script <- function(con, script_name) {
  # Path to script
  path_to_script <- file.path(Sys.getenv("EXAMPLES"), script_name)
  
  # Read the SQL script file into a character string
  sql_script <- paste(readLines(path_to_script), collapse = "\n")
  
  # Execute the SQL script
  # dbExecute() is used for non-query commands (like CREATE or INSERT).
  # For SELECT queries, you would use `dbGetQuery()` instead.
  dbExecute(con, sql_script)
}

load_table <-function(con, table_name, path_to_csv_file) {
  df <- read_csv(path_to_csv_file, show_col_types = FALSE)
  dbAppendTable(con, table_name, df)
}

path_to_database <- paste0(Sys.getenv("EXAMPLES"), "Boxscores.db")

# Connect 
con <- dbConnect(RSQLite::SQLite(), path_to_database)

# Drop Boxscores, Players and Teams tables
execute_script(con, "drop_boxscores_table.sql")
execute_script(con, "drop_players_table.sql")
execute_script(con, "drop_teams_table.sql")

# Create Tables
execute_script(con, "boxscores_create_table.sql")
execute_script(con, "players_create_table.sql")
execute_script(con, "teams_create_table.sql")

# Reload database
load_table(con, "Boxscores", paste0(Sys.getenv("EXAMPLES"), "boxscores.csv"))
load_table(con, "Players", paste0(Sys.getenv("EXAMPLES"), "player_id.csv"))
load_table(con, "Teams", paste0(Sys.getenv("EXAMPLES"), "team_id.csv"))

# Get table names
table_names <- dbListTables(con)
print(table_names)

# Disconnect from the database  
dbDisconnect(con)

print("Done")
