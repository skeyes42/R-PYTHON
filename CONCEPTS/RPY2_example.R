calculate_points <- function(py_df) {
  # Data comes in as R dataframe from Python
  df <- py_df
  
  # Calculate points in R
  df$PTS_R <- df$FGM * 2 + df$FG3M * 3 + df$FTM
  
  print("R processing:")
  print(df[, c('PLAYER_ID', 'FGM', 'FG3M', 'FTM', 'PTS_R')])
  
  return(df)
}

# Create an R-side variable accessible from Python
message_from_r <- "Data processed in R"