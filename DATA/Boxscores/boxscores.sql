/* Drop all the tables -- start from the scratch */
.read drop_all_tables.sql

/* Create tables in Boxscores data with script of SQL commands */
.read boxscores_create_tables.sql

/* Load tables by importing .csv files */
.read boxscores_load_tables.sql
