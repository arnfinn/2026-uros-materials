# Workshop plan: chat interfaces for data with querychat

A 90-minute, in-person, live-coded session. Participants work in official
statistics (national statistical institutes and similar bodies, from several
countries) and have beginner to intermediate R and some Shiny. They work on a
prepared Posit Workbench instance where models are reached through
`ellmer::chat_aws_bedrock()`. The data is `bigfoot.csv`: 5,021 reported
sightings with location, date, a classification, weather on the day, and a
free-text narrative.

The plan follows backward design: the outcomes come first, then the evidence
that shows each outcome was met, then the session that produces that evidence.

## Learning goal

Participants leave able to add a chat interface to a Shiny app with querychat,
and to say what makes its answers trustworthy.

The one idea to remember: the model writes queries, and it does not know your
data. An answer is as good as the context you supply and the checks you put on
screen.

## Framing

The session opens on an opportunity: language models make it possible to ask
a dataset a question in plain language. Two conditions decide whether the
answer can be trusted. The number has to come from the data, through a query
the model wrote, and not from the model itself. And the model has to know
what the data means (what a column holds, what the team's words mean, which
formula is official), which is not in the data for it to find. Our role
changes from answering questions to preparing the data to answer them.

That preparation is three jobs, and each tool in the session does one:

| Job | Tool | Step |
|---|---|---|
| Make every answer checkable | querychat | Chat with a data frame |
| Write down what we know | data-dict | Data dictionary |
| Guarantee the numbers that matter | commons | Trusted calculations |

The session does not present chat as a way to clear a backlog of requests.
The opening stays general, without figures or named studies, and the session
spends its time on guidance for the model and guardrails around its answers.

## Outcomes

Seven outcomes do not get equal depth in 90 minutes, so they are tiered.

Participants can do these unaided:

1. Add querychat to a Shiny app and connect `df()`, `sql()` and `title()` to
   outputs.
2. Read generated SQL and say whether it answers the question asked.

Participants can do these with a worked example beside them:

3. Extend a data dictionary to fix a wrong answer.
4. Write a commons measure (an R function the agent is allowed to call as a
   trusted calculation) and see the answer's label change to Trusted.

Participants can explain these:

5. The path of a question: text, schema, SQL, DuckDB, data frame, Shiny
   outputs.
6. Why the same app runs unchanged on a database, and what a database makes
   possible that a data frame does not.
7. What data-dict validation adds, and when to reach for commons over
   querychat.

Misconceptions the session is built to break:

- The model reads all my rows.
- The model computes the answer.
- A confident answer is a correct answer.
- I have to write SQL to use this.
- This only works on a data frame small enough to load into R.

## Evidence

| Outcome | What participants do that shows it |
|---|---|
| 1 | Show the chat's `title()` in a card header without instructions |
| 2 | Given a question and two candidate queries, pick the wrong one and say why |
| 3 | Add two glossary terms, ask the question again, and see the whole room arrive at the same count |
| 4 | Write one measure, ask the same question before and after, and report the label each time |
| 5 | Predict what the model receives (column names, all rows, the narratives), then check the prediction against the system prompt |
| 6 | Predict what changes in the app when the data frame is swapped for a database connection, then watch the swap |
| 7 | In the wrap-up, sort three scenarios into querychat, commons, or neither |

## The data, as participants meet it

Participants work with one data frame, one row per report, for the whole
session. It is what someone who works in R expects, and every hands-on step
uses it.

The witness narratives are not in that data frame. They total about 9.5 MB of
text, far more than a model should receive in a query result, so the app
keeps them in a separate file and looks one up when a report is opened.

The same table also exists in a DuckDB database file. DuckDB is a database
that runs inside the R session with no server to set up. The instructor uses
the file for one demo, and nothing about the table differs: same rows, same
columns, same name.

## The finished app

Participants see and use the finished app before they write any code. It is a
dashboard called the Field Office: a chat in the sidebar, and a map, a
timeline, a table of reports and the current SQL in the main panel. It runs on
the data frame with the data dictionary in place.

Three questions asked during the opening each preview a later step:

- A filter question (reports in Washington in summer), which redraws the map.
  This previews the first querychat app.
- A jargon question (Class A reports under a full moon in the Pacific
  Northwest). This previews the data dictionary step.
- A calculation question (what share of reports in each season are Class A).
  The chat produces a number, and nobody in the room can guarantee the
  formula behind it. This previews the commons step.

## Session

| Minutes | Step | Checkpoint reached | Outcomes |
|---|---|---|---|
| 8 | Taste the cake | `04-dictionary.R`, run as the finished app | |
| 5 | Shiny review (demo) | `01-shiny.R` | |
| 20 | Chat with a data frame | `02-querychat.R` | 1, 2, 5 |
| 5 | The same app on a database (demo) | `03-database.R` | 6 |
| 12 | Data dictionary | `04-dictionary.R` | 3, 7 |
| 20 | Trusted calculations with commons | `05-commons.R` | 4, 7 |
| 20 | Wrap-up and buffer | | 7 |

Every hands-on step has the same rhythm: participants predict, then type, then
check the prediction against what happened. The Shiny review and the database
step are demonstrations.

### Taste the cake

The instructor runs the finished app and asks the three preview questions.
Participants open the same app and ask one question of their own. This doubles
as the check that every participant's model connection works, before any code
depends on it.

### Shiny review

The starting point is the Field Office without any chat: a dropdown for state
filters the map and the table. The instructor draws the reactive graph on
screen (input, reactive expression, outputs), runs the app, changes the state,
and points at the three parts in the code. Participants watch and type
nothing; their working file already holds this app.

The review ends on the sentence that sets up the rest of the session: the
next step replaces the dropdown with a chat, and the filtered data stays an
ordinary reactive.

### Chat with a data frame

Participants replace the dropdown with querychat. The map, timeline and table
are already written; only the querychat lines are typed.

- Predict: what does the model receive when you ask a question? Column names,
  every row, the narratives?
- Type: create the `QueryChat` object, put its sidebar in the page, start its
  server, swap the filtered reactive for `df()`, show `sql()` and `title()`.
- Check: read the system prompt to settle the prediction. Then ask a question
  and read the SQL it produced.

Two evidence tasks close the step: show the chat's title in a card header
unaided, and pick the wrong query out of two.

### The same app on a database (demo)

The instructor demonstrates; participants watch. The `03-database` checkpoint
holds the result for anyone who wants to run it afterwards.

The demo opens with a prediction: what will change in the app when the data
frame is swapped for a connection to a DuckDB file holding the same table?

The instructor makes the swap, which is one argument, and asks the same
question as before. The app behaves the same and the SQL is the same. The
reason is the reveal: querychat had already loaded the data frame into DuckDB
without saying so, and the SQL participants read in the previous step was
DuckDB's all along. Handing querychat the database directly only removes the
loading step.

The instructor then copies the SQL out of the app and runs it against the
database from the console. The same rows come back. The SQL is ordinary SQL
that anyone can rerun and check, with or without the app.

Two spoken points close the demo, for the participants who will take this to
work:

- In a database the rows stay where they are. The model sees the schema, and
  only query results travel.
- A database holds many related tables, and the model can write joins across
  them. One of the take-home exercises does this.

### Data dictionary

The step starts with an experience, before any explanation. Every participant
asks their own app for Class A reports under a full moon in the Pacific
Northwest and writes down the count. The counts differ across the room.

The model is not ignorant here: it knows that a `moon_phase` of 0.5 is a full
moon. The question is ambiguous. The model decides on its own which states
make up the Pacific Northwest and how wide a full moon is, and it does not
decide the same way every time. In eight test runs the answers were 8, 10 or
11 reports.

- Predict: after reading the SQL, which words in the question did the model
  have to define for itself?
- Type: in the provided `data-dict.yaml`, add glossary entries for "full
  moon" and "Pacific Northwest", then pass the file to querychat.
- Check: ask again. Every participant gets 30 reports, as six test runs out
  of six did.

The framing for real use: official statistics is full of words like these
(unemployed, household, urban area), each with a published definition, and two
people who ask the same question should not bring different numbers to the
same meeting.

The instructor then demonstrates data-dict as a contract between the
dictionary and the data: drafting a dictionary from the data, validating the
data against it with one deliberate mismatch, and the rendered site a
colleague could browse. Participants watch this part.

### Trusted calculations with commons

The whole step asks one question three times: what does Class A mean, and what
share of reports in each season are Class A? Asking for the meaning is what
leads the agent to quote the dictionary in the middle row; without it the
agent rarely does. The numbers never change. The label on the answer does,
and each change comes from one thing participants add.

| The agent has | How it answers | Label |
|---|---|---|
| The data only | Writes its own SQL | Untrusted |
| The data and the dictionary | Writes its own SQL and quotes the dictionary's definition of Class A | Cited |
| The data, the dictionary and a measure | Runs the measure | Trusted |

The instructor shows the first row as the step's own small taste.
Participants then build the other two.

- Predict: the dictionary from the previous step is about to be handed to the
  agent. Will the answer change? Will the label?
- Type: the `dictionary` argument of the data source, then relaunch and ask.
- Check: read the label and open the citation.

Participants then write the calculation themselves as an R function, which is
the part of this stack closest to their daily work.

- Predict: what will the label be once the agent has a function for this
  question?
- Type: one measure that computes the share of Class A reports by season or
  by state, and the `semantic_layer` argument that points the agent at it.
  Relaunch.
- Check: ask the same question and read the label. Then ask which states have
  the highest share, and see the same function answer a second question.

The agent uses the same data and the same dictionary as the querychat app, so
the dictionary written for one tool pays off in the other. The comparison to
draw: querychat drives a dashboard and shows its SQL so a person can check
it; commons answers questions with calculations a team has already vetted and
labels where each answer came from.

### Wrap-up and buffer

Participants sort three scenarios into querychat, commons, or neither. The
instructor points to the take-home material. Fifteen of the twenty minutes are
unallocated.

## If time runs short

Cuts are made in this order, and each one has a prepared fallback:

1. The data-dict validation demo shrinks to one slide.
2. In the first querychat step, the title and the reset button are skipped.
3. The commons step becomes an instructor demo from the `05-commons`
   checkpoint.

The rest of the first querychat step and the dictionary edit are not cut.

## Checkpoints

Each checkpoint is a complete, runnable snapshot of the project at the end of
a step. A participant who falls behind opens the next checkpoint and rejoins.
Code that does not teach querychat (the map, the plots, the data preparation)
lives in a shared helper file that participants never edit.

`03-database.R` is a side branch: the later checkpoints continue from the data
frame version.

Participants edit `app.R`, which starts as a copy of `01-shiny.R`, and later
`commons-app.R`. `04-dictionary.R` is both the end of the dictionary step and
the finished app shown at the start. The completed dictionary and the measure
are in `solutions/`.

## Take-home material

- Several tables in one database: reports, weather and a table of states,
  with a question that needs a join (reports per million residents).
- Chat filters, R tests: `df()` feeds a comparison of the filtered subset with
  the rest, including a formal test.
- Witness statements: a second model call summarizes the narratives of the
  filtered reports.
- Charts in the chat with the querychat visualization tool.

## To verify before building

- One dictionary file serves querychat, data-dict validation and commons. The
  file follows the data-dict specification. querychat 0.4.2 reads an older
  layout, so `querychat_dict()` in `helpers.R` adapts the file for it. A
  newer querychat on Workbench may not need the adapter; the preflight script
  shows whether the dictionary is being read.
- data-dict is an early preview. Its demo needs a rehearsal on Workbench and
  screenshots as a fallback.
- The opening of the dictionary step depends on the room getting different
  counts for the same question. It needs a rehearsal with the workshop model.
- querychat names differ between releases (the filtering tool is `filter` in
  one and `update` in another). The Workbench version decides which the
  checkpoints use.
- commons labels. Cited depends on the model choosing to quote the
  dictionary. With the question worded to ask for the meaning of Class A it
  did so in five test runs out of five; with the shorter question, once in
  ten. The step needs a rehearsal with the workshop model.
- commons runs the agent's R code in an operating-system sandbox. This worked
  on macOS and has not been tried on Workbench. A host without sandbox support
  needs `options(commons.allow_unsafe_fallback = TRUE)`.
- Response time. A question took between 4 and 30 seconds in local runs
  against Bedrock, with no identified cause for the spread. The session
  timings assume the short end.
- querychat saves each conversation in a `.shinychat` folder beside the app
  and restores it, filter included, when the page is reloaded. Participants
  who restart the app will see their earlier chat.
