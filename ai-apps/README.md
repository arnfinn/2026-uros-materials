# Chat with your data, and trust the answers

Materials for a 90-minute workshop on building chat interfaces for data with
querychat, using 5,021 Bigfoot sighting reports.

## For participants

You edit two files during the session: `app.R` and, near the end,
`commons-app.R`. To run an app, open its file and click **Run App**, or run
`shiny::runApp("app.R")` in the console.

If you fall behind, open the numbered file for the step that just ended and
carry on from there. Each one is a complete app.

| File | What it is |
|---|---|
| `app.R` | Your working file. It starts as a copy of `01-shiny.R`. |
| `01-shiny.R` | The dashboard with a dropdown, where we start |
| `02-querychat.R` | The dashboard with a chat in place of the dropdown |
| `03-database.R` | The same app reading from a database file |
| `04-dictionary.R` | The finished dashboard, with the data dictionary |
| `commons-app.R` | Your working file for the last part |
| `05-commons.R` | The finished agent, with the dictionary and a measure |
| `data-dict.yaml` | The data dictionary you will complete |
| `solutions/` | The completed dictionary and the measure |
| `take-home.md` | Exercises and links for afterwards |

`helpers.R` draws the map, the timeline and the table. You do not need to
open it.

## For instructors

Start with `instructor/instructor-guide.md`. The slides are in
`slides/workshop.qmd`, and `docs/workshop-plan.md` records how the session was
designed.

## The data

The reports come from the Bigfoot Field Researchers Organization, by way of
[Timothy Renner's dataset on data.world](https://data.world/timothyrenner/bfro-sightings-data)
and the TidyTuesday project. `data-raw/prepare-data.R` builds the files in
`data/` from `bigfoot.csv`.
