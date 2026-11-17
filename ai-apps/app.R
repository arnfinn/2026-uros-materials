library(shiny)
library(bslib)

source("helpers.R")

bigfoot <- readRDS("data/bigfoot.rds")

ui <- page_sidebar(
  title = "Bigfoot Field Office",
  theme = field_office_theme,
  sidebar = sidebar(
    selectInput(
      "state",
      "State",
      choices = c("All states", sort(unique(bigfoot$state)))
    )
  ),

  layout_columns(
    fill = FALSE,
    value_box(
      title = "Reports",
      value = textOutput("n_reports"),
      showcase = bsicons::bs_icon("binoculars")
    ),
    value_box(
      title = "States",
      value = textOutput("n_states"),
      showcase = bsicons::bs_icon("geo-alt")
    ),
    value_box(
      title = "Class A share",
      value = textOutput("class_a_share"),
      showcase = bsicons::bs_icon("eye")
    )
  ),

  layout_columns(
    col_widths = c(7, 5),
    min_height = "320px",
    card(
      full_screen = TRUE,
      card_header("Where"),
      leafletOutput("map")
    ),
    card(
      full_screen = TRUE,
      card_header("When"),
      plotOutput("timeline")
    )
  ),

  card(
    full_screen = TRUE,
    min_height = "300px",
    card_header("Reports"),
    DT::DTOutput("table")
  )
)

server <- function(input, output, session) {
  # The reports that match the chosen state. Every output below reads this.
  reports <- reactive({
    if (input$state == "All states") {
      bigfoot
    } else {
      dplyr::filter(bigfoot, state == input$state)
    }
  })

  output$n_reports <- renderText({
    format(nrow(reports()), big.mark = ",")
  })
  output$n_states <- renderText({
    length(unique(reports()$state))
  })
  output$class_a_share <- renderText({
    share <- mean(reports()$classification == "Class A")
    paste0(round(100 * share), "%")
  })

  output$map <- renderLeaflet(sightings_map(reports()))
  output$timeline <- renderPlot(sightings_timeline(reports()), res = 96)
  output$table <- DT::renderDT(reports_table(reports()))

  # Open a report from the map or from the table.
  observeEvent(input$map_marker_click, {
    showModal(report_modal(input$map_marker_click$id))
  })
  observeEvent(input$table_rows_selected, {
    selected <- reports()$number[input$table_rows_selected]
    showModal(report_modal(selected))
  })
}

shinyApp(ui, server)
