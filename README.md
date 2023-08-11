
# shinybisonpic

<!-- badges: start -->

[![R-CMD-check](https://github.com/poissonconsulting/shinybisonpic/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/poissonconsulting/shinybisonpic/actions/workflows/R-CMD-check.yaml)
[![deploy-app](https://github.com/poissonconsulting/shinybisonpic/actions/workflows/deploy-app.yaml/badge.svg)](https://github.com/poissonconsulting/shinybisonpic/actions/workflows/deploy-app.yaml)
<!-- badges: end -->

`shinybisonpic` is a Shiny app for visualizing wood bison camera trap
data and preparing the raw data for modeling.

## Usage

### How to Install the R Package

To install the developmental version from
[GitHub](https://github.com/poissonconsulting/shinybisonpic)

``` r
# install.packages("remotes")
remotes::install_github("poissonconsulting/shinybisonpic")
```

### How to Launch the App with Code

``` r
# install.packages("shinybisonpic")
library(shinybisonpic)
run_bisonpic_app()
```

### How to Launch the App with RStudio Addins Button

1.  Install the package
2.  Click on the Addins drop-down and select Start shinybisonpic App

### Overview of How to Use the App

- Download the template for the tab
- Fill in the template with your data
- Upload your raw data
- View the locations spatially
- Explore ratios of sex-age classes
- Download cleaned and processed data ready for demographic modelling

## Contribution

Please report any
[issues](https://github.com/poissonconsulting/shinybisonpic/issues).

## Code of Conduct

Please note that the shinybisonpic project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
