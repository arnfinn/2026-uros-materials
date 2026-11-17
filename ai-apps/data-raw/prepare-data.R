# Builds the workshop data from the raw BFRO sightings export.
# Run from the project root: Rscript data-raw/prepare-data.R

library(dplyr)

raw <- readr::read_csv("bigfoot.csv", show_col_types = FALSE) |>
  mutate(number = as.integer(number)) |>
  arrange(number)

# The table the chat queries, one row per report. The witness narratives are
# left out: a single one can run to tens of thousands of characters, and a
# query result that returned them would be far more text than a model should
# be handed.
bigfoot <- raw |>
  select(
    number, title, date, season, state, county, latitude, longitude,
    classification,
    temperature_high, temperature_mid, temperature_low, dew_point, humidity,
    cloud_cover, moon_phase, precip_intensity, precip_probability,
    precip_type, pressure, summary, uv_index, visibility, wind_bearing,
    wind_speed
  )

# The narratives, looked up by report number when someone opens a report.
narratives <- raw |>
  select(
    number, title, date, state, county, classification, location_details,
    observed
  )

dir.create("data", showWarnings = FALSE)
saveRDS(bigfoot, "data/bigfoot.rds")
saveRDS(narratives, "data/narratives.rds")

# The same table as a parquet file, which is what the data dictionary is
# validated against.
nanoparquet::write_parquet(as.data.frame(bigfoot), "data/bigfoot.parquet")

# The same table in a DuckDB database file.
unlink("data/bigfoot.duckdb")
con <- DBI::dbConnect(duckdb::duckdb(), "data/bigfoot.duckdb")
DBI::dbWriteTable(con, "bigfoot", bigfoot)
DBI::dbDisconnect(con, shutdown = TRUE)
