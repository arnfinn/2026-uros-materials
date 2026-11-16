# Your turn: add a trusted calculation

querychat lets the model write *any* SQL. That is great for exploration, but
your team probably already has calculations it trusts, with decisions baked in
that a model cannot guess. commons lets you hand those calculations to the
agent and shows users which answers came from them.

## 1. Run the agent (2 min)

Run `app.R` and ask:

> What share of Oregon reports are eyewitness sightings, for each season?

Look at the marker under the answer. Which path did the agent take? Look at the
code it wrote. Did it exclude Class C reports? The "Unknown" season?

## 2. Write the measure (6 min)

Your team's rule for the "eyewitness share" is:

- exclude Class C reports (too few and unreliable),
- exclude reports with an `Unknown` season,
- eyewitness share = proportion of Class A among the remaining reports.

Open `measures/bigfoot.R` and add a function `eyewitness_share_by_season()`
modeled on `reports_per_decade()`:

- a roxygen title and description (the model reads these to decide when to use it),
- `@param state` with a type in backticks,
- the `@measure` tag,
- a first argument named `bigfoot`: commons passes the database connection
  for the `bigfoot` data source there.

## 3. Test it (2 min)

Restart the app and ask the same question. What changed in the answer? In the
marker? Now ask a question your measure does *not* cover, e.g.
"How many reports mention snow in Montana?". What happens?

## Discuss

- What other calculations in your work would you want to be "trusted"?
- Who should be allowed to edit `measures/`?
