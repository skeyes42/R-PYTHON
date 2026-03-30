library(RSQLite)
library(DBI)
library(readr)

# Set up paths to resources
path_to_data     <- Sys.getenv("EXAMPLES")
path_to_database <- file.path(path_to_data, "boxscores.db")
path_to_csv      <- file.path(path_to_data, "boxscores.csv")

# Get connection
db_connection <- dbConnect(RSQLite::SQLite(), path_to_database)

# Get boxscore dataframe from csv file
df_boxscores <- read_csv(path_to_csv, show_col_types = FALSE)

# Append data to Boxscores table
dbWriteTable(db_connection, "Boxscores", df_boxscores, overwrite = TRUE)

# Disconnect
dbDisconnect(db_connection)

# View the boxscore data you just loaded
print(df_boxscores)
print("Done")
