library(dplyr)
library(tidyr)
library(readr)

# Create the sample data
boxscores <- tibble(
  GAME_ID = c(1000, 1000, 1000, 1000, 2000, 2000, 2000, 2000, 3000, 3000, 3000, 3000),
  TEAM_ID = c(100, 100, 200, 200, 100, 100, 300, 300, 200, 200, 300, 300),
  PLAYER_ID = c(1, 2, 3, 4, 1, 2, 5, 6, 3, 4, 5, 6),
  FGM = c(10, 4, 2, 8, 10, 11, 8, 7, 5, 3, 4, 8),
  FGA = c(13, 16, 20, 16, 21, 16, 14, 16, 13, 17, 8, 16),
  FG3M = c(12, 4, 6, 2, 4, 5, 10, 6, 7, 2, 4, 3),
  FG3A = c(13, 8, 13, 8, 13, 8, 13, 8, 13, 8, 13, 8),
  FTM = c(12, 7, 5, 7, 10, 4, 9, 3, 9, 6, 11, 3),
  FTA = c(12, 8, 12, 8, 12, 8, 12, 8, 12, 8, 12, 8)
)

cat("Original Boxscore Data:\n")
print(boxscores)

# Join the table to itself on GAME_ID and TEAM_ID
# This pairs each player with their teammate(s) in the same game
teammate_pairs <- boxscores |>
  inner_join(
    boxscores,
    by = c("GAME_ID", "TEAM_ID"),
    suffix = c("_p1", "_p2")
  ) |> write_csv("self_join.csv") 

  cat("\n self_join resutls")
  print(teammate_pairs)

  teammate_pairs <- teammate_pairs |>
  # Avoid pairing a player with themselves
  # Use < instead of != to avoid duplicate pairs (1,2) and (2,1)
  filter(PLAYER_ID_p1 < PLAYER_ID_p2)

cat("\n\nTeammate Pairs (via self-join):\n")
print(teammate_pairs |> select(GAME_ID, TEAM_ID, PLAYER_ID_p1, PLAYER_ID_p2,
                                FGM_p1, FGM_p2, FG3M_p1, FG3M_p2))

# Calculate how much each pair's scoring differed in a game
teammate_analysis <- teammate_pairs |>
  mutate(
    # Total points (simplified: 2*FGM + FG3M + FTM)
    PTS_p1 = 2 * FGM_p1 + FG3M_p1 + FTM_p1,
    PTS_p2 = 2 * FGM_p2 + FG3M_p2 + FTM_p2,
    PTS_diff = abs(PTS_p1 - PTS_p2),
    higher_scorer = if_else(PTS_p1 > PTS_p2, PLAYER_ID_p1, PLAYER_ID_p2)
  ) |>
  select(GAME_ID, TEAM_ID, PLAYER_ID_p1, PLAYER_ID_p2, 
         PTS_p1, PTS_p2, PTS_diff, higher_scorer)

cat("\n\nTeammate Scoring Comparison:\n")
print(teammate_analysis)

# Shows which teams have balanced vs. star-dependent scoring
team_balance <- teammate_analysis |>
  group_by(TEAM_ID) |>
  summarise(
    games_played = n_distinct(GAME_ID),
    avg_teammate_gap = mean(PTS_diff),
    max_teammate_gap = max(PTS_diff),
    .groups = "drop"
  ) |>
  arrange(avg_teammate_gap)

cat("\n\nTeam Scoring Balance (lower gap = more balanced):\n")
print(team_balance)