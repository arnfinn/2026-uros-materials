# Outputs for the Field Office dashboard: the map, the timeline, the table of
# reports and the report reader. Each function takes a data frame of reports
# with the columns of the `bigfoot` table.

library(leaflet)
library(ggplot2)

narratives <- readRDS("data/narratives.rds")

# Page theme. Long SQL wraps inside its box and does not scroll sideways, and
# the table of reports uses smaller text so more columns fit.
field_office_theme <- bslib::bs_add_rules(
  bslib::bs_theme(version = 5),
  "
  pre.shiny-text-output { white-space: pre-wrap; }
  table.dataTable { font-size: 0.875rem; }
  "
)

class_colors <- c(
  "Class A" = "#0072B2",
  "Class B" = "#E69F00",
  "Class C" = "#7F7F7F"
)

# Adapts a data-dict.yaml file for querychat 0.4.2, which reads an older
# layout of the format: tables keyed by name, and each range as a named
# minimum and maximum. Returns the path of the adapted copy.
querychat_dict <- function(path) {
  dict <- yaml::read_yaml(path)

  tables <- lapply(dict$tables, function(table) {
    table$columns <- lapply(table$columns, function(column) {
      if (length(column$range) == 2) {
        column$range <- list(min = column$range[[1]], max = column$range[[2]])
      }
      column
    })
    table
  })
  names(tables) <- vapply(tables, function(table) table$name, character(1))
  dict$tables <- tables

  adapted <- file.path(tempdir(), paste0("querychat-", basename(path)))
  yaml::write_yaml(dict, adapted)
  adapted
}

# Map of the reports that have coordinates. Clicking a marker sets
# `input$<map id>_marker_click`, whose `id` is the report number.
sightings_map <- function(reports) {
  located <- reports[!is.na(reports$latitude) & !is.na(reports$longitude), ]
  located$label <- ifelse(
    is.na(located$title),
    paste("Report", located$number),
    located$title
  )
  pal <- colorFactor(unname(class_colors), levels = names(class_colors))

  map <- leaflet(located) |>
    addProviderTiles(providers$Esri.WorldGrayCanvas)

  if (nrow(located) == 0) {
    return(setView(map, lng = -98.5, lat = 39.8, zoom = 4))
  }

  map |>
    addCircleMarkers(
      lng = ~longitude,
      lat = ~latitude,
      layerId = ~number,
      label = ~label,
      radius = 5,
      stroke = FALSE,
      fillColor = ~ pal(classification),
      fillOpacity = 0.6
    ) |>
    addLegend(
      position = "bottomright",
      pal = pal,
      values = names(class_colors),
      opacity = 0.8,
      title = NULL
    )
}

# Reports per year, stacked by classification. Reports without a date are
# left out.
sightings_timeline <- function(reports) {
  dated <- reports[!is.na(reports$date), ]
  shiny::validate(
    shiny::need(nrow(dated) > 0, "No matching reports have a date.")
  )
  dated$year <- as.integer(format(dated$date, "%Y"))

  ggplot(dated, aes(year, fill = classification)) +
    geom_bar(width = 0.9) +
    scale_fill_manual(values = class_colors, drop = FALSE) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
    labs(x = NULL, y = NULL, fill = NULL) +
    theme_minimal(base_size = 14) +
    theme(
      legend.position = "top",
      legend.text = element_text(size = 12),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank()
    )
}

# Table of reports. Selecting a row sets `input$<table id>_rows_selected` to
# the row's position in `reports`.
reports_table <- function(reports) {
  shown <- reports[, c("number", "date", "state", "classification", "title")]
  # The report number has its own column, so drop it from the headline.
  shown$title <- sub("^Report \\d+: ", "", shown$title)

  shorten <- DT::JS(
    "function(data, type) {",
    "  if (type !== 'display' || !data || data.length <= 60) return data;",
    "  return data.substr(0, 60) + '…';",
    "}"
  )

  DT::datatable(
    shown,
    colnames = c("Report", "Date", "State", "Class", "Title"),
    rownames = FALSE,
    selection = "single",
    fillContainer = TRUE,
    class = "compact hover nowrap",
    options = list(
      dom = "t",
      paging = FALSE,
      scrollX = TRUE,
      columnDefs = list(list(targets = 4, render = shorten))
    )
  )
}

# Dialog showing one report's narrative, looked up by report number.
report_modal <- function(report_number) {
  report <- narratives[narratives$number == report_number, ]
  if (nrow(report) != 1) {
    return(shiny::modalDialog("Report not found.", easyClose = TRUE))
  }

  or_unknown <- function(x) if (is.na(x)) "unknown" else as.character(x)
  facts <- paste(
    or_unknown(report$classification),
    paste(report$county, report$state, sep = ", "),
    paste("date", or_unknown(report$date)),
    sep = " · "
  )

  shiny::modalDialog(
    title = if (is.na(report$title)) {
      paste("Report", report$number)
    } else {
      report$title
    },
    shiny::tags$p(class = "text-muted", facts),
    if (!is.na(report$location_details)) {
      shiny::tags$p(shiny::tags$strong("Location: "), report$location_details)
    },
    shiny::tags$p(
      style = "white-space: pre-wrap;",
      or_unknown(report$observed)
    ),
    size = "l",
    easyClose = TRUE,
    footer = shiny::modalButton("Close")
  )
}
