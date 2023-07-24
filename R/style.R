css_styling <- function() {
  x <- "
  .navbar-white {
    background-color: #F1F1F1;
  }

  a {
    color: #0070C4
  }

  .checkbox-inline {
	  margin-left: 20px;
  }

  "
  tags$style(x, type = "text/css")
}
