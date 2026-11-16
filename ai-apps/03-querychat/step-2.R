# Step 2: put querychat inside your own app
#
# Goal: the chat filters the data, and *your* outputs react to the filtered data.
# The three querychat pieces you need:
#   qc$sidebar()          -> UI: the chat in a sidebar
#   qc_vals <- qc$server() -> server: starts the chat, returns reactives
#   qc_vals$df()           -> the current filtered data frame
# Replace each ___ and run the file.

library(shiny)
library(bslib)
library(ggplot2)
library(querychat)
source("../_llm.R")

bigfoot <- readRDS("../data/bigfoot.rds")

qc <- QueryChat$new(bigfoot, client = workshop_chat())

ui <- page_sidebar(
  title = "Bigfoot sightings explorer",
  sidebar = ___,
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
  qc_vals <- ___

  output$year_plot <- renderPlot({
    ggplot(___, aes(year)) +
      geom_bar() +
      labs(x = NULL, y = "Number of reports")
  })

  output$table <- DT::renderDT({
    DT::datatable(___, options = list(pageLength = 5))
  })
}

shinyApp(ui, server)

# Compare with 01-shiny-basics/app.R: what replaced selectInput() and
# sliderInput()? What stayed exactly the same?
