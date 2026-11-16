# Step 4: polish and trust
#
# Goal: make the app trustworthy for your users.
#  1. Show the current filter title and SQL query (qc_vals$title(), qc_vals$sql())
#  2. Add value boxes that summarize the filtered data
#  3. Add a greeting so users know what they can ask
# Stretch: add a leaflet map of the filtered reports (see the TODO below).

library(shiny)
library(bslib)
library(ggplot2)
library(querychat)
source("../_llm.R")

bigfoot <- readRDS("../data/bigfoot.rds")

greeting <- "
Hi! I can filter and summarize **BFRO bigfoot reports**.

Try for example:
- <span class=\"suggestion\">Show Class A reports from the Pacific Northwest</span>
- <span class=\"suggestion\">___</span>
"

qc <- QueryChat$new(
  bigfoot,
  client = workshop_chat(),
  greeting = greeting,
  data_description = "bigfoot-description.md",
  extra_instructions = "
- Remind users that reports are not verified observations.
- When computing averages of weather variables, say how many reports had missing values.
"
)

ui <- page_sidebar(
  title = "Bigfoot sightings explorer",
  sidebar = qc$sidebar(),
  layout_columns(
    fill = FALSE,
    value_box("Reports", textOutput("n_reports")),
    value_box("Class A (eyewitness)", textOutput("pct_class_a")),
    value_box("States", ___)
  ),
  card(
    card_header(textOutput("title")),
    verbatimTextOutput("sql")
  ),
  layout_columns(
    card(card_header("Reports per year"), plotOutput("year_plot")),
    card(card_header("Reports"), DT::DTOutput("table"))
  )
  # TODO (stretch): add a card with leaflet::leafletOutput("map")
)

server <- function(input, output, session) {
  qc_vals <- qc$server()

  output$title <- renderText(qc_vals$title() %||% "All reports")
  output$sql <- renderText(___ %||% "SELECT * FROM bigfoot")

  output$n_reports <- renderText(format(nrow(qc_vals$df()), big.mark = ","))
  output$pct_class_a <- renderText({
    df <- qc_vals$df()
    scales::percent(mean(df$classification == "Class A"), accuracy = 1)
  })
  output$n_states <- renderText(___)

  output$year_plot <- renderPlot({
    ggplot(qc_vals$df(), aes(year)) +
      geom_bar() +
      labs(x = NULL, y = "Number of reports")
  })

  output$table <- DT::renderDT({
    DT::datatable(qc_vals$df(), options = list(pageLength = 5))
  })

  # TODO (stretch): output$map <- leaflet::renderLeaflet({ ... })
  # Use leaflet() |> addTiles() |> addCircleMarkers(lng = ~longitude, lat = ~latitude)
}

shinyApp(ui, server)
