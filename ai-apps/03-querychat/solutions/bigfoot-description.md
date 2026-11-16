This dataset contains reports of bigfoot sightings collected by the Bigfoot
Field Researchers Organization (BFRO). There is one row per report. Weather
values come from the Dark Sky API for the report's date and location.
Reports are self-reported accounts, not verified observations.

- report_id: BFRO report number. An identifier, never sum or average it.
- title: Short headline written by BFRO.
- state, county: Location of the report (United States).
- season: Season of the event (Fall, Spring, Summer, Winter, Unknown).
- classification: BFRO credibility class.
  - Class A: clear eyewitness sighting where misidentification is unlikely.
    When users ask about "credible", "eyewitness", or "visual" sightings, use
    Class A.
  - Class B: something was heard or found (sounds, tracks) but not clearly
    seen.
  - Class C: second-hand or otherwise low-reliability reports. Very rare.
- date, year: Date of the event. About 19% of reports have no date; these
  reports also have no coordinates or weather. Missing means "not geocoded",
  not "date unknown to the witness".
- latitude, longitude: Approximate location in decimal degrees.
- temperature_high, temperature_low: Daily high and low, in degrees Fahrenheit.
- humidity, cloud_cover: Fractions between 0 and 1.
- moon_phase: Fraction of the lunar cycle, 0 = new moon, 0.5 = full moon.
- precip_type: rain, snow, or missing when there was no precipitation data.
- wind_speed: Miles per hour.
- visibility: Miles, capped at 10. "Good viewing conditions" means high
  visibility and low cloud cover.
- weather_summary: Short text summary of the day's weather.
