library(commons)

bigfoot <- readRDS("data/bigfoot.rds")

# The data the agent may query.
sightings <- data_source(
  bigfoot = bigfoot
)

agent <- commons(
  client = ellmer::chat_aws_bedrock(),
  data_sources = list(sightings = sightings)
)

commons_app(agent)
