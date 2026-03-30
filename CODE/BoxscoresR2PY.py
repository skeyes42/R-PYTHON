import pandas as pd
import rpy2.robjects as ro
from rpy2.robjects.packages import importr
from rpy2.robjects import pandas2ri
from rpy2.robjects.conversion import localconverter

import os

# Install S7 package in R via rpy2 and utils package
utils = importr('utils')

packnames_to_install = ('S7',)

# Get list of installed R packages
packages = utils.installed_packages()
package_names = [p for p in packages.rx(True, 1)]

# If S7 is not installed, install it
if 'S7' not in package_names:
    utils.install_packages(ro.StrVector(list(packnames_to_install)))

# Import the S7 package into the rpy2 session
s7 = importr('S7')

r_file_path = os.getenv("EXAMPLES") + "LIBRARY/" + "BoxscoresClass.R"
with open(r_file_path, 'r') as file:
    r_code = file.read()

# Execute the R code string
ro.r(r_code)

# Access and convert the R dataframe
with localconverter(ro.default_converter + pandas2ri.converter) as cv:
    r_function = ro.r['get_Boxscores_data']
    
    df_from_r = r_function()

# Use the pandas DataFrame in Python ---
print("\nPandas DataFrame:")
print(df_from_r)

print("Done")

