library(tibble)
library(S7)

# Your flat data
df <- tibble::tribble(
  ~GAME_ID, ~TEAM_ID, ~PLAYER_ID, ~FGM, ~FG3M, ~FTM,
      1000L,      100L,          1L,   10L,    12L,   12L,
      1000L,      100L,          2L,    4L,     4L,    7L,
      1000L,      200L,          3L,    2L,     6L,    5L,
      1000L,      200L,          4L,    8L,     2L,    7L,
      2000L,      100L,          1L,   10L,     4L,   10L,
      2000L,      100L,          2L,   11L,     5L,    4L,
      2000L,      300L,          5L,    8L,    10L,    9L,
      2000L,      300L,          6L,    7L,     6L,    3L
)

Player <- new_class("Player",
  properties = list(
    player_id = class_integer,
    fgm = class_integer,
    fg3m = class_integer,
    ftm = class_integer
  )
)

Game <- new_class("Game",
  properties = list(
    game_id = class_integer,
    players = class_list
  )
)

Season <- new_class("Season",
  properties = list(
    games = class_list
  )
)

# Transform flat data to hierarchical structure
build_season <- function(df) {
  games_list <- list()

  for (gid in unique(df$GAME_ID)) {
    game_data <- df[df$GAME_ID == gid, ]

    players_list <- list()
    for (i in seq_len(nrow(game_data))) {
      players_list[[i]] <- Player(
        player_id = as.integer(game_data$PLAYER_ID[i]),
        fgm       = as.integer(game_data$FGM[i]),
        fg3m      = as.integer(game_data$FG3M[i]),
        ftm       = as.integer(game_data$FTM[i])
      )
    }

    games_list[[length(games_list) + 1]] <- Game(
      game_id = gid,
      players = players_list
    )
  }

  Season(games = games_list)
}


season <- build_season(df)

# hierarchical access
cat("=== Flat/Relational Access ===\n")
cat("Player 1's FGM in game 1000:", df$FGM[df$GAME_ID == 1000 & df$PLAYER_ID == 1], "\n\n")

cat("=== Hierarchical/OO Access ===\n")
cat("Player 1's FGM in game 1000:", season@games[[1]]@players[[1]]@fgm, "\n\n")

# show structure
cat("=== Season Structure ===\n")
cat("Number of games:", length(season@games), "\n")
cat("Players in game 1:", length(season@games[[1]]@players), "\n")
cat("Players in game 2:", length(season@games[[2]]@players), "\n")
