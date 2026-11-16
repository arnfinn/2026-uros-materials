This dataset contains reports of bigfoot sightings collected by the Bigfoot
Field Researchers Organization (BFRO). There is one row per report. Weather
values come from the Dark Sky API for the report's date and location.

- report_id: BFRO report number. An identifier, never sum or average it.
- title: Short headline written by BFRO.
- state, county: Location of the report (United States).
- season: Season of the event (Fall, Spring, Summer, Winter, Unknown).
- classification: TODO: explain what Class A, Class B, and Class C mean.
  (Hint: see https://www.bfro.net/gdb/classify.asp)
- date, year: Date of the event. TODO: what does a missing date mean?
- latitude, longitude: TODO
- temperature_high, temperature_low: Daily high and low, in degrees Fahrenheit.
- humidity, cloud_cover, moon_phase: TODO: what are the units and ranges?
- precip_type: rain, snow, or missing when there was no precipitation data.
- wind_speed: Miles per hour.
- visibility: Miles, capped at 10.
- weather_summary: Short text summary of the day's weather.
