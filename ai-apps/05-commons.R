library(commons)

bigfoot <- readRDS("data/bigfoot.rds")

# The data the agent may query, described by the same dictionary the
# querychat app uses.
sightings <- data_source(
  bigfoot = bigfoot,
  dictionary = "solutions/data-dict.yaml"
)

# Every R function tagged @measure in the folder becomes a calculation the
# agent can run and label Trusted.
agent <- commons(
  client = ellmer::chat_aws_bedrock(),
  data_sources = list(sightings = sightings),
  semantic_layer = semantic_layer("solutions/measures")
)

commons_app(agent)
