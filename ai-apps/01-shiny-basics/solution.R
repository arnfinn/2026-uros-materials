library(shiny)
library(bslib)
library(ggplot2)

bigfoot <- readRDS("../data/bigfoot.rds")

ui <- page_sidebar(
  title = "Bigfoot sightings",
  sidebar = sidebar(
    selectInput(
      "season",
      "Season",
      choices = c("Fall", "Spring", "Summer", "Winter", "Unknown")
    ),
    sliderInput("bins", "Number of bins", min = 5, max = 50, value = 20)
  ),
  card(
    card_header("Daily high temperature on the day of the sighting"),
    plotOutput("temp_plot"),
    textOutput("n_reports")
  )
)

server <- function(input, output, session) {
  season_data <- reactive({
    bigfoot[bigfoot$season == input$season, ]
  })

  output$temp_plot <- renderPlot({
    message("drawing plot for ", input$season)
    ggplot(season_data(), aes(temperature_high)) +
      geom_histogram(bins = input$bins) +
      labs(x = "Temperature (°F)", y = "Number of reports")
  })

  output$n_reports <- renderText({
    paste(nrow(season_data()), "reports")
  })
}

shinyApp(ui, server)
