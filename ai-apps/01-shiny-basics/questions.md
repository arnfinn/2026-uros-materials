# Exploring a Shiny app

Run `app.R` (click the play button at the top of the editor). Then work through
these questions with your neighbor. Change the code, re-run, and observe.

1. **Inputs.** Find the two inputs in the UI. What is the ID of each one? Where
   in the server is each ID used?
2. **Outputs.** The plot is created in the server as `output$temp_plot` and
   displayed in the UI with `plotOutput("temp_plot")`. What happens if you
   rename only one of them?
3. **Reactivity.** Add `message("drawing plot for ", input$season)` as the first
   line inside `renderPlot()`. Watch the console as you move the slider and
   change the season. When does the code run? When does it *not* run?
4. **A new input.** Add `"Unknown"` to the season choices. What changes?
5. **A new output.** Add a line of text under the plot that says how many
   reports are shown. Hint: you need a `textOutput()` in the UI and a
   `renderText()` in the server.
6. **Bonus.** You now compute `season_data` twice. Move it into a
   `reactive()` and use it in both outputs. Why might this matter for a slow
   computation?

Keep in mind for later: in this app, *you* decided in advance which questions
the user can ask (season and bins). What if users want to ask questions you
did not anticipate?
