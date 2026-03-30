library(S7)

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

#--------------------- Boxscore class ----------------------------------------
Boxscore <- new_class("Boxscore",
  properties = list(
    data = class_data.frame
  ),
  validator = function(self) {
    required_cols <- c("GAME_ID", "TEAM_ID", "PLAYER_ID", "FGM", "FG3M", "FTM")
    missing <- setdiff(required_cols, names(self@data))
    if (length(missing) > 0) {
      paste("Missing required columns:", paste(missing, collapse = ", "))
    }
  }
)

method(print, Boxscore) <- function(x, ...) {
  n_rows <- nrow(x@data)
  n_games <- length(unique(x@data$GAME_ID))
  cat(sprintf("Boxscore: %d rows, %d games\n\n", n_rows, n_games))
  print(x@data)
  invisible(x)
}

#--------------------- main program  ----------------------------------------
box <- Boxscore(data = df)
print(box)

