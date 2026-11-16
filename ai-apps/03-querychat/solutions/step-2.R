library(shiny)
library(bslib)
library(ggplot2)
library(querychat)
source("../../_llm.R")

bigfoot <- readRDS("../../data/bigfoot.rds")

qc <- QueryChat$new(bigfoot, client = workshop_chat())

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
