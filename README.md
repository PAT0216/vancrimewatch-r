# VanCrimeWatch (R)

A mini R Shiny dashboard for exploring Vancouver crime data (2023-2025).
This is an individual assignment re-implementation of the group [VanCrimeWatch](https://github.com/UBC-MDS/DSCI-532_2026_4_VanCrimeWatch) project built in Python Shiny.

## Features

- **Neighbourhood filter**: Dropdown to filter crimes by neighbourhood
- **Crime type filter**: Dropdown to filter by crime category
- **Crime Timeline**: Interactive Plotly line chart showing monthly incident counts per year
- **Data Table**: Searchable, paginated table of filtered crime records

## Installation

Install the required R packages:

```r
install.packages(c("shiny", "dplyr", "plotly", "DT", "readr"))
```

## Running Locally

```r
shiny::runApp("app.R")
```

Or from the terminal:

```bash
Rscript -e "shiny::runApp('app.R')"
```

## Deployed App

[Link to deployed app on Posit Connect Cloud](https://pat0216-vancrimewatch-r.share.connect.posit.cloud/)