# Step 1: querychat out of the box
#
# Goal: get a working "chat with your data" app with a single function call.
# Replace each ___ and run the file.

library(querychat)
source("../_llm.R")

bigfoot <- readRDS("../data/bigfoot.rds")

querychat_app(___, client = ___)

# Try asking:
# - "Show only Class A reports from Washington"
# - "How many reports are there per season?"
# - "Which state has the most reports in winter?"
#
# Look at the SQL shown above the table. Is it what you would have written?
