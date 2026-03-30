# Define the scripts to run in order
scripts <- c(
  "ManiputeDBwithScript.R",
  "ComputePercentagesPoints.R",
  "SelfJoinBuildWinLoss.R",
  "SummarizeTeamLevel.R"
)

# Function to run a script with error handling
run_script <- function(script_name) {
  cat("\n========================================\n")
  cat("Running:", script_name, "\n")
  cat("========================================\n")
  
  tryCatch({
    source(script_name, echo = TRUE)
    cat("\n✓ Successfully completed:", script_name, "\n")
    return(TRUE)
  }, error = function(e) {
    cat("\n✗ Error in", script_name, ":\n")
    cat(conditionMessage(e), "\n")
    return(FALSE)
  })
}

# Main execution
cat("Starting R Pipeline\n")
cat("Date/Time:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")

# Track execution results
results <- data.frame(
  script = character(),
  status = character(),
  stringsAsFactors = FALSE
)

# Run each script
for (script in scripts) {
  setwd("/home/stevie/DLUBU/EXAMPLES/CODE")
  success <- run_script(script)
  results <- rbind(results, data.frame(
    script = script,
    status = ifelse(success, "SUCCESS", "FAILED")
  ))
  
  # Stop pipeline if a script fails
  if (!success) {
    cat("\n!!! Pipeline stopped due to error !!!\n")
    break
  }
}

# Summary
cat("\n========================================\n")
cat("Pipeline Execution Summary\n")
cat("========================================\n")
print(results)

# Check if all succeeded
all_success <- all(results$status == "SUCCESS")
if (all_success) {
  cat("\n✓ All scripts completed successfully!\n")
} else {
  cat("\n✗ Pipeline completed with errors.\n")
  quit(status = 1)
}