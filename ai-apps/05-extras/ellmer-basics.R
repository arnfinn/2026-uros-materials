# ellmer: the layer underneath querychat and commons
#
# querychat = ellmer chat + a system prompt about your data + SQL tools.
# Here we build the core idea by hand.

library(ellmer)
source("../_llm.R")

bigfoot <- readRDS("../data/bigfoot.rds")

# 1. A plain chat ------------------------------------------------------------
chat <- workshop_chat(system_prompt = "You are a terse statistician.")
chat$chat("In one sentence: what is a data dictionary?")

# 2. Structured output: turn free text into data ----------------------------
chat <- workshop_chat()
chat$chat_structured(
  "Report 1517: Horse-riding witnesses see hairy bipedal animal cross trail on Blackfeet Reservation",
  type = type_object(
    n_witnesses_mentioned = type_boolean(
      "Does the title mention several witnesses?"
    ),
    activity = type_string("What the witnesses were doing, one or two words")
  )
)

# 3. A tool: let the model call R code you wrote ----------------------------
count_reports <- tool(
  function(state) sum(bigfoot$state == state),
  name = "count_reports",
  description = "Count the number of bigfoot reports in a US state.",
  arguments = list(state = type_string("Full US state name, e.g. 'Ohio'"))
)

chat <- workshop_chat()
chat$register_tool(count_reports)
chat$chat("Are there more reports in Ohio or in Oregon?")

# The model never saw the data: it asked R to run count_reports() twice.
# querychat does the same thing, with a tool that runs SQL instead.
