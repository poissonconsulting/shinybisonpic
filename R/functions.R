# Convert Template ----

check_template <- function(x) {
  chk::chk_data(x)
  chk::chk_superset(names(x), "name")
  chk::chk_superset(x$name, c("description", "pkey", "chk"),
               x_name = "template column names"
  )
  invisible(x)
}

chkrow_to_expression <- function(x) {
  check_template(x)
  x <- x[x$name == "chk", ]
  chkvals <- row_expr(x)
  names(chkvals) <- names(x)[-1]
  chkvals
}

add_row <- function(x, y) {
  x[nrow(x) + 1, ] <- y
  x
}

rm_na <- function(x) {
  x[!is.na(x)]
}

parse_eval <- function(x) eval(parse(text = x))

row_expr <- function(x) {
  lapply(row_char(x), parse_eval)
}

row_char <- function(x) {
  as.character(as.vector(x))[-1]
}

lgl_to_yesno <- function(x) {
  if (x == TRUE & !is.na(x)) {
    return("yes")
  }
  "no"
}

lgls_to_yesno <- function(x) {
  sapply(x, lgl_to_yesno)
}

chk_to_missing <- function(x) {
  if (any(is.na(x))) {
    return("yes")
  }
  "no"
}

chk_to_constraint <- function(x) {
  y <- sort(rm_na(x))
  type <- class(y)
  type <- switch(type,
                 "numeric" = "number",
                 "character" = "word(s)", type
  )
  if (length(y) == 1) {
    return(paste("any", type))
  }
  if (length(y) == 2) {
    if (type %in% c("integer", "number")) {
      return(paste(type, "between", chk::cc(y, " and ")))
    }
  }
  paste("one of", chk::cc(y, " or "))
}

template_human <- function(template) {
  check_template(template)

  x <- as.data.frame(template[template$name == "description", ])
  chk_vals <- chkrow_to_expression(template)

  # examples
  examples <- row_char(template[template$name == "example", ])
  x <- add_row(x, c("example", examples))

  # constraints
  x <- add_row(x, c("constraint", sapply(chk_vals, chk_to_constraint)))

  # missing
  x <- add_row(x, c("missing_allowed", sapply(chk_vals, chk_to_missing)))

  # unique
  if ("unique" %in% template$name) {
    lgls <- lgls_to_yesno(row_char(template[template$name == "unique", ]))
    x <- add_row(x, c("unique", lgls))
  }

  tibble::as_tibble(x)
}


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
