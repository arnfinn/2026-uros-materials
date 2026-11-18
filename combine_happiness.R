# Combine the 2015-2019 World Happiness Report CSVs into one tidy,
# long-format file (one row per country-year).

library(tidyverse)

# ---- Read each year's file -------------------------------------------------

y2015 <- read_csv("2015.csv")
y2016 <- read_csv("2016.csv")
y2017 <- read_csv("2017.csv")
y2018 <- read_csv("2018.csv")
# 2018's "Perceptions of corruption" is read as character because UAE's
# value is the literal string "N/A"; convert to numeric NA.
y2018 <- y2018 |>
  mutate(`Perceptions of corruption` = na_if(`Perceptions of corruption`, "N/A") |> as.numeric())
y2019 <- read_csv("2019.csv")

# ---- Region lookup from 2015/2016 ------------------------------------------
# Region was only reported in 2015 and 2016. Build a lookup and reconcile
# country-name spelling differences used in 2017-2019 before joining.

region_lookup <- bind_rows(
  y2015 |> select(Country, Region),
  y2016 |> select(Country, Region)
) |>
  distinct(Country, Region)

country_aliases <- tribble(
  ~alias, ~Country,
  "Taiwan Province of China", "Taiwan",
  "Hong Kong S.A.R., China", "Hong Kong",
  "Trinidad & Tobago", "Trinidad and Tobago",
  "Northern Cyprus", "North Cyprus",
  "North Macedonia", "Macedonia"
)

region_lookup_aliased <- country_aliases |>
  left_join(region_lookup, by = "Country") |>
  select(Country = alias, Region)

region_lookup_full <- bind_rows(region_lookup, region_lookup_aliased)

# ---- Rename each year to a common schema -----------------------------------

y2015_clean <- y2015 |>
  transmute(
    country = Country,
    region = Region,
    year = 2015L,
    rank = `Happiness Rank`,
    score = `Happiness Score`,
    gdp_per_capita = `Economy (GDP per Capita)`,
    social_support = Family,
    health_life_expectancy = `Health (Life Expectancy)`,
    freedom = Freedom,
    trust_corruption = `Trust (Government Corruption)`,
    generosity = Generosity
  )

y2016_clean <- y2016 |>
  transmute(
    country = Country,
    region = Region,
    year = 2016L,
    rank = `Happiness Rank`,
    score = `Happiness Score`,
    gdp_per_capita = `Economy (GDP per Capita)`,
    social_support = Family,
    health_life_expectancy = `Health (Life Expectancy)`,
    freedom = Freedom,
    trust_corruption = `Trust (Government Corruption)`,
    generosity = Generosity
  )

y2017_clean <- y2017 |>
  left_join(region_lookup_full, by = "Country") |>
  transmute(
    country = Country,
    region = Region,
    year = 2017L,
    rank = `Happiness.Rank`,
    score = `Happiness.Score`,
    gdp_per_capita = `Economy..GDP.per.Capita.`,
    social_support = Family,
    health_life_expectancy = `Health..Life.Expectancy.`,
    freedom = Freedom,
    trust_corruption = `Trust..Government.Corruption.`,
    generosity = Generosity
  )

y2018_clean <- y2018 |>
  left_join(region_lookup_full, by = c("Country or region" = "Country")) |>
  transmute(
    country = `Country or region`,
    region = if_else(`Country or region` == "Gambia", "Sub-Saharan Africa", Region),
    year = 2018L,
    rank = `Overall rank`,
    score = Score,
    gdp_per_capita = `GDP per capita`,
    social_support = `Social support`,
    health_life_expectancy = `Healthy life expectancy`,
    freedom = `Freedom to make life choices`,
    trust_corruption = `Perceptions of corruption`,
    generosity = Generosity
  )

y2019_clean <- y2019 |>
  left_join(region_lookup_full, by = c("Country or region" = "Country")) |>
  transmute(
    country = `Country or region`,
    region = if_else(`Country or region` == "Gambia", "Sub-Saharan Africa", Region),
    year = 2019L,
    rank = `Overall rank`,
    score = Score,
    gdp_per_capita = `GDP per capita`,
    social_support = `Social support`,
    health_life_expectancy = `Healthy life expectancy`,
    freedom = `Freedom to make life choices`,
    trust_corruption = `Perceptions of corruption`,
    generosity = Generosity
  )

# ---- Combine and write ------------------------------------------------------

happiness_all <- bind_rows(
  y2015_clean, y2016_clean, y2017_clean, y2018_clean, y2019_clean
) |>
  relocate(country, region, year)

write_csv(happiness_all, "happiness_2015_2019.csv")
