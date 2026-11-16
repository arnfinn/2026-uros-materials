#' Reports per decade for a state
#'
#' Number of BFRO reports per decade for one state, counting only geocoded
#' reports (reports with a known year). This is the calculation used in our
#' team's annual bigfoot summary.
#'
#' @param state `string` Full US state name, e.g. "Washington".
#' @return A table with one row per decade and the number of reports.
#' @measure
reports_per_decade <- function(bigfoot, state) {
  dplyr::tbl(bigfoot, "bigfoot") |>
    dplyr::filter(state == !!state, !is.na(year)) |>
    dplyr::mutate(decade = floor(year / 10) * 10) |>
    dplyr::count(decade, name = "n_reports") |>
    dplyr::arrange(decade) |>
    dplyr::collect()
}

#' Eyewitness share by season for a state
#'
#' Proportion of reports that are eyewitness sightings (Class A), per season,
#' for one state. Following team rules, Class C reports and reports with an
#' Unknown season are excluded.
#'
#' @param state `string` Full US state name, e.g. "Oregon".
#' @return A table with one row per season: number of reports and eyewitness share.
#' @measure
eyewitness_share_by_season <- function(bigfoot, state) {
  dplyr::tbl(bigfoot, "bigfoot") |>
    dplyr::filter(
      state == !!state,
      classification != "Class C",
      season != "Unknown"
    ) |>
    dplyr::group_by(season) |>
    dplyr::summarize(
      n_reports = dplyr::n(),
      eyewitness_share = mean(
        as.numeric(classification == "Class A"),
        na.rm = TRUE
      )
    ) |>
    dplyr::arrange(season) |>
    dplyr::collect()
}
