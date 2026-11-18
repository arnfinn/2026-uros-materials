happiness <- readr::read_csv("happiness_2015_2019.csv", show_col_types = FALSE)

all_countries <- happiness |> dplyr::distinct(country) |> dplyr::arrange(country) |> dplyr::pull(country)
year_range <- range(happiness$year)

default_countries <- c("United States", "Norway", "Finland", "Brazil")
default_countries <- default_countries[default_countries %in% all_countries]

ui <- bslib::page_sidebar(
  title = "World Happiness: Country Trajectories",
  theme = bslib::bs_theme(version = 5),
  sidebar = bslib::sidebar(
    shiny::selectizeInput(
      "countries", "Countries",
      choices = all_countries,
      selected = default_countries,
      multiple = TRUE,
      options = list(placeholder = "Select one or more countries")
    ),
    shiny::sliderInput(
      "years", "Years",
      min = year_range[1], max = year_range[2],
      value = year_range, step = 1, sep = ""
    )
  ),
  bslib::layout_column_wrap(
    width = 1,
    bslib::card(
      full_screen = TRUE,
      bslib::card_header("Happiness score over time"),
      shiny::plotOutput("score_plot")
    ),
    bslib::card(
      full_screen = TRUE,
      bslib::card_header("Happiness rank over time (lower is happier)"),
      shiny::plotOutput("rank_plot")
    )
  )
)

server <- function(input, output, session) {

  filtered <- shiny::reactive({
    happiness |>
      dplyr::filter(
        country %in% input$countries,
        year >= input$years[1],
        year <= input$years[2]
      )
  })

  output$score_plot <- shiny::renderPlot({
    shiny::validate(shiny::need(nrow(filtered()) > 0, "Select at least one country."))

    ggplot2::ggplot(filtered(), ggplot2::aes(x = year, y = score, color = country)) +
      ggplot2::geom_line(linewidth = 1) +
      ggplot2::geom_point(size = 2) +
      ggplot2::scale_x_continuous(breaks = year_range[1]:year_range[2]) +
      ggplot2::labs(x = "Year", y = "Happiness score", color = "Country") +
      ggplot2::theme_minimal()
  })

  output$rank_plot <- shiny::renderPlot({
    shiny::validate(shiny::need(nrow(filtered()) > 0, "Select at least one country."))

    ggplot2::ggplot(filtered(), ggplot2::aes(x = year, y = rank, color = country)) +
      ggplot2::geom_line(linewidth = 1) +
      ggplot2::geom_point(size = 2) +
      ggplot2::scale_x_continuous(breaks = year_range[1]:year_range[2]) +
      ggplot2::scale_y_reverse() +
      ggplot2::labs(x = "Year", y = "Overall rank", color = "Country") +
      ggplot2::theme_minimal()
  })
}

shiny::shinyApp(ui, server)
