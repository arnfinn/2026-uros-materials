library(commons)
source("../_llm.R")

bigfoot <- readRDS("../data/bigfoot.rds")

agent <- commons(
  client = workshop_chat(),
  data_sources = list(
    bigfoot = data_source(
      bigfoot = bigfoot,
      dictionary = "dictionaries/bigfoot.yaml"
    )
  ),
  semantic_layer = semantic_layer("measures"),
  context_layer = context_layer("context/bigfoot.md"),
  instructions = "instructions.md"
)
