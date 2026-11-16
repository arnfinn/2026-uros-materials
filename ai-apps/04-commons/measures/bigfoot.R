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

# YOUR TURN: add a second measure below. See ../exercise.md.
