# Prepare the workshop copy of the BFRO bigfoot sightings data.
# Source: TidyTuesday 2022-09-13 (BFRO reports, weather from Dark Sky).
# Run once by the instructor; participants receive data/bigfoot.rds.

library(readr)
library(dplyr)

raw <- read_csv(
  "/Users/francois/git/2026-uRos-materials/EDA/bigfoot.csv",
  show_col_types = FALSE
)

bigfoot <- raw |>
  transmute(
    report_id = as.integer(number),
    title = sub("^Report [0-9]+: ", "", title),
    state,
    county,
    season,
    classification,
    date,
    year = as.integer(format(date, "%Y")),
    latitude,
    longitude,
    temperature_high,
    temperature_low,
    humidity,
    cloud_cover,
    moon_phase,
    precip_type,
    wind_speed,
    visibility,
    weather_summary = summary
  ) |>
  # Keep the bad coordinate in Montana (longitude -144) on purpose:
  # it is a good "trust but verify" teaching moment.
  arrange(report_id)

saveRDS(bigfoot, "bigfoot.rds")
