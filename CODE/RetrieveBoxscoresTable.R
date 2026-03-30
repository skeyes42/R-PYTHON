library(RSQLite)
library(DBI)
library(dplyr)

# Connect
path_to_database <- file.path(Sys.getenv("EXAMPLES"), "Boxscores.db")

con <- dbConnect(RSQLite::SQLite(), path_to_database)
  
# Get ALL data from Boxscores table
query <- tbl(con, "Boxscores") |>
  select(everything())
  
  # Look at SQL commands that this query builds
show_query(query)

# Actually get the Boxscores data -- using collect against the query
results_df <- query |>
  collect()
  
dbDisconnect(con)

print(results_df, width = Inf)
print("Done")