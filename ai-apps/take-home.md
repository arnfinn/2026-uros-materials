# After the workshop

Four exercises that extend what we built, in rough order of difficulty, and
the documentation for each tool.

## 1. Ask the same question five times

Take a question from your own work that uses one of your organization's
words: "active", "last quarter", a region name. Put a table of your own behind
`02-querychat.R` and ask the question five times, clearing the filter in
between. Compare the SQL.

Then write the two or three glossary entries that would make the five answers
agree. This is the fastest way to find out what a dictionary for your data
needs to say.

## 2. Charts in the chat

querychat can draw charts inside the conversation. In `04-dictionary.R`, list
the tools when creating the chat:

```r
qc <- QueryChat$new(
  bigfoot,
  client = ellmer::chat_aws_bedrock(),
  greeting = "greeting.md",
  data_dict = querychat_dict("solutions/data-dict.yaml"),
  tools = c("filter", "query", "visualize")
)
```

Ask for a bar chart of reports by season. Then filter the dashboard to one
state and ask for the same chart. Does the chart follow the dashboard's
filter? Read the querychat article on visualization to see why.

## 3. Chat filters, R tests

The chat chooses the reports; R does the statistics. In `04-dictionary.R`, add
a card that compares the filtered reports with all the others on one weather
variable, for example the day's high temperature.

Hints:

- `reports()` holds the filtered rows. The others are the rows of `bigfoot`
  whose `number` is not in `reports()$number`.
- A box plot with the two groups side by side is a good first output. A
  `t.test()` or a permutation test is a good second one.
- Many reports have no weather data. Decide what to do with them, and say so
  on the card.

The question to think about: sightings cluster in summer and in populated
places. What would a difference in temperature between your filtered reports
and the rest tell you, and what would it not?

## 4. Several tables

Real databases hold many related tables. Split the data into two tables, one
for the reports and one for the weather on each report's day, joined by
`number`. Add a third table with one row per state; R's built-in `state.x77`
has a population column, from the 1970s.

Register the tables with `qc$add_table()`, describe how they join in the
`relationships` section of a data dictionary, and ask: which states have the
most reports per million residents?

Read the SQL. Did the model join on the columns you expected?

## Documentation

- querychat: <https://posit-dev.github.io/querychat/r/>
- The data-dict format and its command-line tool: <https://data-dict.tidyverse.org/>
- commons: <https://posit-dev.github.io/commons/r/>
- ellmer, which connects R to language models: <https://ellmer.tidyverse.org/>
- Shiny and bslib: <https://shiny.posit.co/> and <https://rstudio.github.io/bslib/>
