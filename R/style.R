# default colour for interactive objects: #0070C4
# light background colour: #F1F1F1

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

  table.dataTable tr.selected td, table.dataTable td.selected {
    box-shadow: inset 0 0 0 9999px #0070C4 !important;
  }

  "
  tags$style(x, type = "text/css")
}
