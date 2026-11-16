# Building AI-powered Shiny apps in R

Hands-on materials for the 90-minute workshop.

## Before you start

Everything is installed in the workshop cloud environment, and the LLM
(Anthropic Claude via AWS Bedrock) is configured in `_llm.R`. Check it works
by running in the console:

```r
source("_llm.R")
workshop_chat()$chat("Say hello in 3 words")
```

## Materials

| Folder | What |
|---|---|
| `01-shiny-basics/` | A small Shiny app and questions to explore how it works |
| `02-demo/` | The finished app we are going to build |
| `03-querychat/` | Build it step by step: `step-1.R` to `step-4.R`, solutions in `solutions/` |
| `04-commons/` | A data agent with trusted calculations; exercise in `exercise.md` |
| `05-extras/` | ellmer basics, evaluating with vitals, data-dict |
| `data/` | `bigfoot.rds` and the script that created it |

Each exercise file has `___` blanks to fill in. If you fall behind, open the
matching file in `solutions/` and continue from there.

## Data

BFRO bigfoot reports via [TidyTuesday 2022-09-13](https://github.com/rfordatascience/tidytuesday/tree/main/data/2022/2022-09-13).
Reports are self-reported, not verified observations.

## Packages

The workshop environment already has everything installed. To reproduce it on
your own machine later, the exact versions are recorded in `renv.lock`:

```r
install.packages("renv")
renv::restore()
```

Main packages: shiny, bslib, querychat, ellmer, commons, vitals, DT, leaflet,
ggplot2, ggsql. The data-dict exercise also needs arrow and the data-dict CLI.
