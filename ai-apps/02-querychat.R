library(shiny)
library(bslib)
library(querychat)

source("helpers.R")

bigfoot <- readRDS("data/bigfoot.rds")

qc <- QueryChat$new(
  bigfoot,
  client = ellmer::chat_aws_bedrock(),
  greeting = "greeting.md"
)

ui <- page_sidebar(
  title = "Bigfoot Field Office",
  theme = field_office_theme,
  sidebar = qc$sidebar(),

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

  layout_columns(
    col_widths = c(7, 5),
    min_height = "300px",
    card(
      full_screen = TRUE,
      card_header(textOutput("title")),
      DT::DTOutput("table")
    ),
    card(
      full_screen = TRUE,
      card_header(
        class = "d-flex justify-content-between align-items-center",
        "Current SQL",
        actionButton("reset", "Show all reports", class = "btn-sm")
      ),
      verbatimTextOutput("sql")
    )
  )
)

server <- function(input, output, session) {
  qc_vals <- qc$server()

  # The reports that match the chat's current filter. Every output below
  # reads this.
  reports <- reactive(qc_vals$df())

  # What else the chat produced: a title and the query itself.
  output$title <- renderText(qc_vals$title() %||% "All reports")
  output$sql <- renderText({
    if (isTruthy(qc_vals$sql())) qc_vals$sql() else "SELECT * FROM bigfoot"
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

  # Clear the filter without going through the chat.
  observeEvent(input$reset, {
    qc_vals$sql("")
    qc_vals$title(NULL)
  })

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
