library(DBI)
library(RSQLite)
library(readr)

path_to_database <- file.path(Sys.getenv("EXAMPLES"), "Boxscores.db")

# Connect to a database
con <- dbConnect(RSQLite::SQLite(), path_to_database)

# Construct the SQL UPDATE statement
sql_update_query <- "UPDATE Players SET PLAYER_NAME = 'Johnie' WHERE PLAYER_ID = 2;"

# Execute the statement
dbExecute(con, sql_update_query)

# Read Players back and print
results_df <- dbReadTable(con, "Players")
print(results_df)

dbDisconnect(con)

print('Done')