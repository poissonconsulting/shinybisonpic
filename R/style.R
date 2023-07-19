css_styling <- function() {
  x <- "
  .navbar-white {
    background-color: #d1d4d3;
  }

  "
  tags$style(x, type = "text/css")
}
