library(shiny)
library(bslib)
library(ggplot2)
library(leaflet)
library(querychat)
source("../../_llm.R")

bigfoot <- readRDS("../../data/bigfoot.rds")

greeting <- "
Hi! I can filter and summarize **BFRO bigfoot reports**.

Try for example:
- <span class=\"suggestion\">Show Class A reports from the Pacific Northwest</span>
- <span class=\"suggestion\">Which state had the most winter reports since 2000?</span>
- <span class=\"suggestion\">Show reports with good viewing conditions</span>
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
    value_box("States", textOutput("n_states"))
  ),
  card(
    fill = FALSE,
    card_header(textOutput("title")),
    verbatimTextOutput("sql")
  ),
  layout_columns(
    card(card_header("Where"), leafletOutput("map")),
    card(card_header("Reports per year"), plotOutput("year_plot"))
  ),
  card(card_header("Reports"), DT::DTOutput("table"))
)

server <- function(input, output, session) {
  qc_vals <- qc$server()

  output$title <- renderText(qc_vals$title() %||% "All reports")
  output$sql <- renderText(qc_vals$sql() %||% "SELECT * FROM bigfoot")

  output$n_reports <- renderText(format(nrow(qc_vals$df()), big.mark = ","))
  output$pct_class_a <- renderText({
    df <- qc_vals$df()
    scales::percent(mean(df$classification == "Class A"), accuracy = 1)
  })
  output$n_states <- renderText(length(unique(qc_vals$df()$state)))

  output$map <- renderLeaflet({
    df <- qc_vals$df()
    df <- df[!is.na(df$latitude) & !is.na(df$longitude), ]
    leaflet(df) |>
      addTiles() |>
      addCircleMarkers(
        lng = ~longitude,
        lat = ~latitude,
        radius = 3,
        stroke = FALSE,
        fillOpacity = 0.5,
        label = ~title
      )
  })

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
