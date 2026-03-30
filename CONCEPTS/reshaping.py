import pandas as pd
import sqlite3
import os

def dump(df):
    print(df)
    print()
    return df

path_to_database = os.path.join(os.environ["EXAMPLES"], "Boxscores.db")
con = sqlite3.connect(path_to_database)

# Bring in player and team names
query = """
    SELECT b.*, p.PLAYER_NAME, t.TEAM_NAME
    FROM Boxscores b
    LEFT JOIN Players p ON b.PLAYER_ID = p.PLAYER_ID
    LEFT JOIN Teams   t ON b.TEAM_ID   = t.TEAM_ID
    ORDER BY b.GAME_ID, b.TEAM_ID
"""
shooting = pd.read_sql(query, con)
shooting = shooting.drop(columns=["PLAYER_ID", "TEAM_ID"])
con.close()

print(shooting)

shooting_summary = (shooting

    # pivot_longer: stack the 6 stat columns into stat_type + count
    .melt(
        id_vars    = ["GAME_ID", "PLAYER_NAME", "TEAM_NAME"],
        value_vars = ["FGM", "FGA", "FG3M", "FG3A", "FTM", "FTA"],
        var_name   = "stat_type",
        value_name = "count"
    )
    .pipe(dump)

    # mutate: split stat_type into shot_type and made_attempt
    .assign(
        shot_type    = lambda df: df["stat_type"].str.replace(r"(M|A)$", "", regex=True),
        made_attempt = lambda df: df["stat_type"].str.extract(r"(M|A)$")
    )
    .drop(columns="stat_type")
    .pipe(dump)

    # pivot_wider: spread M and A into separate columns
    .pivot_table(
        index   = ["GAME_ID", "PLAYER_NAME", "TEAM_NAME", "shot_type"],
        columns = "made_attempt",
        values  = "count",
        aggfunc = "sum"
    )
    .reset_index()
    .pipe(dump)

    # group_by + summarise
    .groupby(["PLAYER_NAME", "TEAM_NAME", "shot_type"])
    .apply(lambda g: pd.Series({
        "attempts": g["A"].sum(),
        "pct":      g["M"].sum() / g["A"].sum() * 100
    }), include_groups=False)
    .reset_index()
)

print(shooting_summary)