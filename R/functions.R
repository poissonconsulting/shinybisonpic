# Table Formatting ----

template_table <- function(data) {
  DT::datatable(
    data,
    escape = FALSE,
    rownames = FALSE,
    selection = "none",
    class = "row-border",
    extensions = "FixedColumns",
    options = list(
      fixedColumns = list(leftColumns = 1),
      ordering = FALSE,
      autowidth = TRUE,
      scrollX = TRUE,
      lengthChange = FALSE,
      searching = FALSE,
      info = FALSE,
      paging = FALSE,
      columnDefs = list(
        list(
          className = "dt-center",
          targets = "_all"
        )
      )
    ),
    container = tags$table(
      class = "row-border",
      tags$thead(
        tags$tr(
          mapply(tags$th, colnames(data), style = sprintf("border-right: solid %spx;", c(0.5, rep(0, ncol(data)-1L))), SIMPLIFY = FALSE)
        )
      )
    )
  ) |>
  DT::formatStyle(1, `border-right` = "solid 0.5px")

}


data_table <- function(data) {
  if (!is.data.frame(data)) {
    return()
  }
  DT::datatable(
    data,
    escape = FALSE,
    rownames = FALSE,
    class = "cell-border compact",
    options = list(
      ordering = TRUE,
      autowidth = TRUE,
      scrollX = TRUE,
      columnDefs = list(
        list(
          className = "dt-center",
          targets = "_all"
        )
      )
    )
  )
}
