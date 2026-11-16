# data-dict: a data dictionary your data can't disagree with

In step 3 we wrote `bigfoot-description.md` by hand, and in the commons
exercise we used `04-commons/dictionaries/bigfoot.yaml`. Two problems with
hand-written documentation:

1. It takes time to write.
2. It drifts: the data changes, the documentation does not.

[data-dict](https://data-dict.tidyverse.org/) addresses both: an agent can
draft the dictionary, and a validator checks the data against it.

## Try it (terminal)

Install (one option, see the site for others):

```r
pak::pak("tidyverse/data-dict/r")
datadict::dd_install()
```

Then, from this folder:

```bash
# Draft a dictionary from the data
data-dict draft bigfoot.parquet

# Check the data matches what the dictionary claims
data-dict validate-data data-dict.yaml

# Render a browsable website
data-dict render-spec data-dict.yaml
```

To create `bigfoot.parquet`:

```r
arrow::write_parquet(readRDS("../data/bigfoot.rds"), "bigfoot.parquet")
```

## Questions

- Edit the dictionary to say `visibility` is at most 10, then change one value
  in the data to 12. What does `validate-data` report?
- querychat (`data_dict =`) and commons (`dictionary =`) both accept a
  data-dict file. Why is a single source of truth valuable here?
