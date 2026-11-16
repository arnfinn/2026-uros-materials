library(querychat)
source("../../_llm.R")

bigfoot <- readRDS("../../data/bigfoot.rds")

querychat_app(bigfoot, client = workshop_chat())
