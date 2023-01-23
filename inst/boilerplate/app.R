library(plumber)

port = 80

pr("plumber.R") %>%
  pr_run(host = "0.0.0.0", port = port, debug = TRUE)
