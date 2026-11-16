# One place to configure the LLM used by every exercise.
# The workshop cloud environment provides AWS credentials for Bedrock.
# The model ID can be overridden with the WORKSHOP_MODEL environment variable.

workshop_model <- function() {
  Sys.getenv(
    "WORKSHOP_MODEL",
    # TODO(instructor): confirm the model ID enabled in the workshop account
    "us.anthropic.claude-sonnet-4-5-20250929-v1:0"
  )
}

workshop_chat <- function(...) {
  ellmer::chat_aws_bedrock(model = workshop_model(), ...)
}
