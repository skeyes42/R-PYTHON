# df <- tibble::tribble(
#   ~GAME_ID, ~TEAM_ID, ~PLAYER_ID, ~FGM, ~FG3M, ~FTM,
#       1000,      100,          1,   10,    12,   12,
#       1000,      100,          2,    4,     4,    7,
#       1000,      200,          3,    2,     6,    5,
#       1000,      200,          4,    8,     2,    7,
#       2000,      100,          1,   10,     4,   10,
#       2000,      100,          2,   11,     5,    4,
#       2000,      300,          5,    8,    10,    9,
#       2000,      300,          6,    7,     6,    3
# )

df <- data.frame(
  GAME_ID = c(1000, 1000, 1000, 1000, 2000, 2000, 2000, 2000),
  TEAM_ID = c(100, 100, 200, 200, 100, 100, 300, 300),
  PLAYER_ID = c(1, 2, 3, 4, 1, 2, 5, 6),
  FGM = c(10, 4, 2, 8, 10, 11, 8, 7),
  FG3M = c(12, 4, 6, 2, 4, 5, 10, 6),
  FTM = c(12, 7, 5, 7, 10, 4, 9, 3)
)

print('--- 1 ---')
a <- df[1]
print(class(a))
print(a)

print('--- 2 ---')
b <- df[1,1]
print(class(b))
print(b)

print('--- 3 ---')
c <- df[1,]
print(class(c))
print(c)

print ('--- 4 ---')
d <- df[,1]
print(class(d))
print(d)

print('--- 5 ---')
x <- df[[1]]
print(class(x))
print(x)

x <

