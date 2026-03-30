import os
import sqlite3
import subprocess

def flush_database(path_to_scripts):

    db_path = os.path.join(path_to_scripts, "Boxscores.db")

    # Command to drop all tables
    drop_command = f".read drop_all_tables.sql"
    subprocess.run(["sqlite3", db_path], 
                   input=drop_command.encode('utf-8'), 
                   check=True, 
                   cwd=path_to_scripts)
        
    # Command to recreate tables
    recreate_command = f".read boxscores.sql"
    subprocess.run(["sqlite3", db_path], input=recreate_command.encode('utf-8'), 
                   check=True, 
                   cwd=path_to_scripts)

def db_list_tables(con):
    cursor = con.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = [row[0] for row in cursor.fetchall()]
    return tables

# Setup path_to_scripts
path_to_scripts = os.getenv("EXAMPLES")

# Flush the database using the function
flush_database(path_to_scripts)

# Connect
path_to_database = os.path.join(path_to_scripts, "Boxscores.db")
con = sqlite3.connect(path_to_database)

# Get list of tables after flushing
before = db_list_tables(con)
print('--- tables after flush_database() ---')
print(before)

# Demonstrate dropping tables manually
print('\n--- manually dropping tables ---')
drop_command = ".read drop_all_tables.sql"
subprocess.run(["sqlite3", path_to_database], 
               input=drop_command.encode('utf-8'), 
               check=True, 
               cwd=path_to_scripts)

# Get list of tables after dropping
after_dropping = db_list_tables(con)
print('--- after dropping ---')
print(after_dropping)

# Demonstrate recreating tables manually
print('\n--- manually recreating tables ---')
recreate_command = ".read boxscores.sql"
subprocess.run(["sqlite3", path_to_database], 
               input=recreate_command.encode('utf-8'), 
               check=True, 
               cwd=path_to_scripts)

# Get list of tables after recreation
after_recreating = db_list_tables(con)
print('--- after recreating ---')
print(after_recreating)

con.close()

print("\nDone")

