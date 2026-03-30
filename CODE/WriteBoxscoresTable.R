library(DBI)
library(RSQLite)
library(readr)

path_to_database <- file.path(Sys.getenv("EXAMPLES"), "Boxscores.db")

con <- dbConnect(RSQLite::SQLite(), path_to_database)

# Create dataframe of Players data to write to Boxscores.db
csv_Players_data <- "PLAYER_ID, PLAYER_NAME
1,Fred
2,John
3,Trevor
4,Alex
5,Jim
6,Steve
7,Herb"

Players_data_df <- read_csv(csv_Players_data, 
                     show_col_types = FALSE,
                     col_types = cols(PLAYER_ID = col_integer(), PLAYER_NAME = col_character())
                     )


# Write the dataframe to a database table
dbWriteTable(con, "Players", Players_data_df, overwrite = TRUE)


# Read Players back and print 
results_df <- dbReadTable(con, "Players")

print(results_df, width = Inf)

dbDisconnect(con)

print('Done')
