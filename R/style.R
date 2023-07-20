css_styling <- function() {
  x <- "
  .navbar-white {
    background-color: #F1F1F1;
  }

  "
  tags$style(x, type = "text/css")
}
