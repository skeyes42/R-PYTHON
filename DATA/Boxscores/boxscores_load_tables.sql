/* Tell SQLite3 that what you're importing are csv files */
.mode csv

/* Load Players table csv data -- except for header row */
.import --skip 1 player_id.csv Players

/* Load Teams table csv data -- except for header row */
.import --skip 1 team_id.csv Teams

/* Load Boxscores table csv data -- except for header row */
.import --skip 1 boxscores.csv Boxscores
