library(reticulate)

# Source the Python script containing the getBoxscores function
source_python("BoxscoresReticulate.py")

# Define the database and table names.
db <- file.path(Sys.getenv("EXAMPLES"), "Boxscores.db")
table <- 'Boxscores'

# Call the Python function.
boxscores_df_r <- getBoxscores(db, table)

print(head(boxscores_df_r))

print("Done")

