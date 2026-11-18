library(shiny)
library(bslib)
library(tidyverse)

happiness <- read_csv("happiness_2015_2019.csv", show_col_types = FALSE)

all_countries <- happiness |> distinct(country) |> arrange(country) |> pull(country)
year_range <- range(happiness$year)

default_countries <- c("United States", "Norway", "Finland", "Brazil")
default_countries <- default_countries[default_countries %in% all_countries]

ui <- page_sidebar(
  title = "World Happiness: Country Trajectories",
  theme = bs_theme(version = 5),
  sidebar = sidebar(
    selectizeInput(
      "countries", "Countries",
      choices = all_countries,
      selected = default_countries,
      multiple = TRUE,
      options = list(placeholder = "Select one or more countries")
    ),
    sliderInput(
      "years", "Years",
      min = year_range[1], max = year_range[2],
      value = year_range, step = 1, sep = ""
    )
  ),
  layout_column_wrap(
    width = 1,
    card(
      full_screen = TRUE,
      card_header("Happiness score over time"),
      plotOutput("score_plot")
    ),
    card(
      full_screen = TRUE,
      card_header("Happiness rank over time (lower is happier)"),
      plotOutput("rank_plot")
    )
  )
)

server <- function(input, output, session) {

  filtered <- reactive({
    happiness |>
      filter(
        country %in% input$countries,
        year >= input$years[1],
        year <= input$years[2]
      )
  })

  output$score_plot <- renderPlot({
    validate(need(nrow(filtered()) > 0, "Select at least one country."))

    ggplot(filtered(), aes(x = year, y = score, color = country)) +
      geom_line(linewidth = 1) +
      geom_point(size = 2) +
      scale_x_continuous(breaks = year_range[1]:year_range[2]) +
      labs(x = "Year", y = "Happiness score", color = "Country") +
      theme_minimal()
  })

  output$rank_plot <- renderPlot({
    validate(need(nrow(filtered()) > 0, "Select at least one country."))

    ggplot(filtered(), aes(x = year, y = rank, color = country)) +
      geom_line(linewidth = 1) +
      geom_point(size = 2) +
      scale_x_continuous(breaks = year_range[1]:year_range[2]) +
      scale_y_reverse() +
      labs(x = "Year", y = "Overall rank", color = "Country") +
      theme_minimal()
  })
}

shinyApp(ui, server)
