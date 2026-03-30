library(S7)
library(dplyr)
library(purrr)

# === BASE CLASS ===
StatLine <- new_class("StatLine",
  properties = list(
    FGM = class_integer,
    FGA = class_integer,
    FG3M = class_integer,
    FG3A = class_integer,
    FTM = class_integer,
    FTA = class_integer
  )
)

# Methods inherited by all children
fg_pct <- new_generic("fg_pct", "x")
method(fg_pct, StatLine) <- function(x) {
  if (x@FGA == 0L) return(NA_real_)
  round(x@FGM / x@FGA, 3)
}

fg3_pct <- new_generic("fg3_pct", "x")
method(fg3_pct, StatLine) <- function(x) {
  if (x@FG3A == 0L) return(NA_real_)
  round(x@FG3M / x@FG3A, 3)
}

ft_pct <- new_generic("ft_pct", "x")
method(ft_pct, StatLine) <- function(x) {
  if (x@FTA == 0L) return(NA_real_)
  round(x@FTM / x@FTA, 3)
}

points <- new_generic("points", "x")
method(points, StatLine) <- function(x) {
  (x@FGM - x@FG3M) * 2L + x@FG3M * 3L + x@FTM
}

poly_print <- new_generic('poly_print', 'x')
method(poly_print, StatLine) <- function(x) {
  print("From parent class")
}

# === CHILD CLASSES ===
PlayerGame <- new_class("PlayerGame",
  parent = StatLine,
  properties = list(
    GAME_ID = class_integer,
    TEAM_ID = class_integer,
    PLAYER_ID = class_integer
  )
)

method(poly_print, PlayerGame) <- function(x) {
  print("From child class")
}


# === CONSTRUCTORS FROM DATA ===


# Build PlayerGame objects from a data frame using dplyr/purrr
player_games_from_df <- function(df) {
  df |>
    select(GAME_ID, TEAM_ID, PLAYER_ID, FGM, FGA, FG3M, FG3A, FTM, FTA) |>
    mutate(across(everything(), as.integer)) |>
    pmap(PlayerGame)
}


# === DEMO ===

# Your data
csv_text <- "GAME_ID,TEAM_ID,PLAYER_ID,FGM,FGA,FG3M,FG3A,FTM,FTA
1000,100,1,10,13,12,13,12,12
1000,100,2,4,16,4,8,7,8
1000,200,3,2,20,6,13,5,12
1000,200,4,8,16,2,8,7,8
2000,100,1,10,21,4,13,10,12
2000,100,2,11,16,5,8,4,8
2000,300,5,8,14,10,13,9,12
2000,300,6,7,16,6,8,3,8
3000,200,3,5,13,7,13,9,12
3000,200,4,3,17,2,8,6,8
3000,300,5,4,8,4,13,11,12
3000,300,6,8,16,3,8,3,8"

# Test polymorphism
stat1 = StatLine(
  FGM = 10L,
  FGA = 20L,
  FG3M = 3L,
  FG3A = 8L,
  FTM = 5L,
  FTA = 6L
)

pg1 <- PlayerGame(
  GAME_ID = 1000L,
  TEAM_ID = 100L,
  PLAYER_ID = 1L,
  FGM = 10L,
  FGA = 13L,
  FG3M = 12L,
  FG3A = 13L,
  FTM = 12L,
  FTA = 12L
)

print('---------- Test polymorphism ----------------')
poly_print(stat1)
poly_print(pg1)
print('---------------------------------------------')
cat('\n')


df <- read.csv(text = csv_text)

# Build all PlayerGame objects
all_games <- player_games_from_df(df)

# Show inheritance in action - same methods work on different classes
cat("=== INHERITANCE DEMO ===\n\n")

# Single game (PlayerGame)
game1 <- all_games[[1]]
cat(sprintf("Player %d, Game %d:\n", game1@PLAYER_ID, game1@GAME_ID))
cat(sprintf("  Points: %d | FG%%: %.1f%% | 3P%%: %.1f%%\n\n",
            points(game1), fg_pct(game1) * 100, fg3_pct(game1) * 100))

# Prove they're different classes sharing behavior
cat("=== CLASS VERIFICATION ===\n")
cat(sprintf("game1 class: %s (parent: %s)\n", 
            class(game1)[1], class(S7_class(game1)@parent)[1]))

