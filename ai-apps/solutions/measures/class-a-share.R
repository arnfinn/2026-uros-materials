#' Share of Class A reports
#'
#' The percentage of sighting reports that the BFRO rated Class A, its rating
#' for a clear sighting, within each group. Every report in a group counts
#' toward the total, whatever its rating.
#'
#' @param by `enum[season, state]` Column that defines the groups.
#' @return A data frame with one row per group: the number of reports, the
#'   number rated Class A, and the Class A share in percent.
#' @measure
class_a_share <- function(by = "season", sightings) {
  by <- match.arg(by, c("season", "state"))
  reports <- DBI::dbReadTable(sightings, "bigfoot")

  reports |>
    dplyr::group_by(group = .data[[by]]) |>
    dplyr::summarize(
      reports = dplyr::n(),
      class_a = sum(classification == "Class A"),
      class_a_share = round(100 * class_a / reports, 1)
    )
}
