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
      choices = c("Fall", "Spring", "Summer", "Winter")
    ),
    sliderInput("bins", "Number of bins", min = 5, max = 50, value = 20)
  ),
  card(
    card_header("Daily high temperature on the day of the sighting"),
    plotOutput("temp_plot")
  )
)

server <- function(input, output, session) {
  output$temp_plot <- renderPlot({
    season_data <- bigfoot[bigfoot$season == input$season, ]
    ggplot(season_data, aes(temperature_high)) +
      geom_histogram(bins = input$bins) +
      labs(x = "Temperature (°F)", y = "Number of reports")
  })
}

shinyApp(ui, server)
