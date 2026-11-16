# vitals: how do you know your querychat app gives correct answers?
#
# An evaluation is a set of questions with known answers (computed by you,
# with code you trust), a solver (the thing being tested), and a scorer.

library(vitals)
library(querychat)
library(tibble)
source("../_llm.R")

bigfoot <- readRDS("../data/bigfoot.rds")

qc <- QueryChat$new(
  bigfoot,
  client = workshop_chat(),
  data_description = "../03-querychat/solutions/bigfoot-description.md"
)

# Targets computed with dplyr in data/prepare-bigfoot.R's output
questions <- tribble(
  ~input                                                                                                               , ~target                         ,
  "Which state has the most reports?"                                                                                  , "Washington, with 601 reports." ,
  "How many Class A reports are there in Washington?"                                                                  , "243"                           ,
  "Which state had the most winter reports from 2000 onward?"                                                          , "Florida, with 47 reports."     ,
  "What is the average daily high temperature for Class A reports?"                                                    ,
  "About 67.5 °F. 856 Class A reports have no temperature and are excluded; the answer should mention missing values."
)

# The solver: a chat client with querychat's read-only query tool attached
task <- Task$new(
  dataset = questions,
  solver = generate(qc$client(tools = "query")),
  scorer = model_graded_qa(scorer_chat = workshop_chat()),
  name = "bigfoot-querychat"
)

task$eval()
task$metrics

# Things to try:
# - Re-run without data_description. Does accuracy change?
# - Use epochs = 3 in Task$new(): how consistent are the answers?
# - task$get_cost()
