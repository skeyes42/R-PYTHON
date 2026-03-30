library(DBI)
library(RSQLite)

path_to_database <- paste0(Sys.getenv("EXAMPLES"), "Boxscores.db")

# Connect 
con <- dbConnect(RSQLite::SQLite(), path_to_database)

# Get table names
table_names <- dbListTables(con)
print(table_names)

# Setup table name
table_name <- "Boxscores" 

# Execute the PRAGMA statement to get table info
column_info <- dbGetQuery(con, 
                          paste0("PRAGMA table_info(", 
                          table_name, ");"))

# Print the column names
print(column_info)

# Disconnect from the database
dbDisconnect(con)