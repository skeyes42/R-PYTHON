import pandas as pd

class Boxscore:
    def __init__(self, data: pd.DataFrame):
        self._data = data
        self._validate()

    def _validate(self):
        required_cols = ["GAME_ID", "TEAM_ID", "PLAYER_ID", "FGM", "FG3M", "FTM"]
        missing = set(required_cols) - set(self._data.columns)
        if missing:
            raise ValueError(f"Missing required columns: {', '.join(missing)}")

    @property
    def data(self) -> pd.DataFrame:
        return self._data

    def __repr__(self):
        n_rows = len(self.data)
        n_games = self.data['GAME_ID'].nunique()
        header = f"Boxscore: {n_rows} rows, {n_games} games\n\n"
        return header + self.data.to_string()

# --------------------- main program ----------------------------------------

# Create the initial DataFrame
df = pd.DataFrame({
    'GAME_ID':    [1000, 1000, 1000, 1000, 2000, 2000, 2000, 2000],
    'TEAM_ID':    [100,  100,  200,  200,  100,  100,  300,  300],
    'PLAYER_ID':  [1,    2,    3,    4,    1,    2,    5,    6],
    'FGM':        [10,   4,    2,    8,    10,   11,   8,    7],
    'FG3M':       [12,   4,    6,    2,    4,    5,    10,   6],
    'FTM':        [12,   7,    5,    7,    10,   4,    9,    3]
})

# Create Boxscore object
box = Boxscore(data=df)

print(box)
