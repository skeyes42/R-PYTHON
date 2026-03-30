/* Direct output to file */
.output "data.csv"

/* Set format of output to csv */
.mode csv

/* Move header column names to output */
.header on

/* Get all Boxscores table rows to output */
SELECT * FROM Season2025;

/* Close ouptut */
.output stdout
