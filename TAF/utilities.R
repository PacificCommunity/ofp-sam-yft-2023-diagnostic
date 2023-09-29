# Show progress while reading file
reading <- function(string, action)
{
  cat("  Reading", string, "... ")
  x <- action
  cat("done\n")
  x
}
