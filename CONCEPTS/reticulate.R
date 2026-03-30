library(reticulate)
library(tibble)

# Create the data in R
df <- tibble::tribble(
  ~GAME_ID, ~TEAM_ID, ~PLAYER_ID, ~FGM, ~FG3M, ~FTM,
      1000,      100,          1,   10,    12,   12,
      1000,      100,          2,    4,     4,    7,
      1000,      200,          3,    2,     6,    5,
      1000,      200,          4,    8,     2,    7,
      2000,      100,          1,   10,     4,   10,
      2000,      100,          2,   11,     5,    4,
      2000,      300,          5,    8,    10,    9,
      2000,      300,          6,    7,     6,    3
)

# Calculate total points in R (FGM*2 + FG3M*3 + FTM)
df$PTS_R <- df$FGM * 2 + df$FG3M * 3 + df$FTM

print("R calculation:")
print(df)

# Pass data to Python
source_python("reticulate.py")

# Call Python function
result <- calculate_points(df)

print("Python calculation returned:")
print(result)

# Get data back from Python
# NOTE: when you load the reticulate library, the py object is 
#       automatically created as a gateway to the Python environment.
#       You can use py to access stuff that was created in the enviroment,
#       like df_python
py_df <- py$df_python

print("Data from Python:")
print(py_df)