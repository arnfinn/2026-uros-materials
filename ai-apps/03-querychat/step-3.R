# Step 3: tell the model about your data
#
# First, run step-2 solution and ask:
#   "What proportion of reports are credible sightings?"
#   "Show me the reports with the best viewing conditions"
# The model has to guess what "credible" and "best viewing conditions" mean.
#
# Goal: give the model the context a colleague would need.
#  1. Complete the TODOs in bigfoot-description.md
#  2. Pass it to QueryChat$new() with `data_description`
#  3. Add one or two `extra_instructions`
# Then ask the same questions again and compare the SQL.

library(shiny)
library(bslib)
library(ggplot2)
library(querychat)
source("../_llm.R")

bigfoot <- readRDS("../data/bigfoot.rds")

qc <- QueryChat$new(
  bigfoot,
  client = workshop_chat(),
  data_description = ___,
  extra_instructions = ___
)

ui <- page_sidebar(
  title = "Bigfoot sightings explorer",
  sidebar = qc$sidebar(),
  card(
    card_header("Reports per year"),
    plotOutput("year_plot")
  ),
  card(
    card_header("Reports"),
    DT::DTOutput("table")
  )
)

server <- function(input, output, session) {
  qc_vals <- qc$server()

  output$year_plot <- renderPlot({
    ggplot(qc_vals$df(), aes(year)) +
      geom_bar() +
      labs(x = NULL, y = "Number of reports")
  })

  output$table <- DT::renderDT({
    DT::datatable(qc_vals$df(), options = list(pageLength = 5))
  })
}

shinyApp(ui, server)

# Curious what the model actually receives? Run in the console:
# cat(qc$system_prompt)
