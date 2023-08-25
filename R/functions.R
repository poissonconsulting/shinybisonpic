#Copyright 2023 Province of Alberta

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

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

# Helper Functions ----
code_sex_age <- function(x) {
  lookup <- c(
    m0 = "male calf",
    m1 = "male yearling",
    ma = "male adult",
    mu = "male unknown",
    m2 = "male 2 yr old",
    m3 = "male 3 yr old",
    f0 = "female calf",
    f1 = "female yearling",
    fa = "female adult",
    fu = "female unknown",
    u0 = "unknown calf",
    u1 = "unknown yearling",
    ua = "unknown adult",
    uu = "unknown unknown"
  )

  id <- match(x, lookup)
  codes <- names(lookup[id])
  codes
}

is_try_error <- function(x){
  inherits(x, "try-error")
}

add_title_newlines <- function(x, max_nchars = 92) {
  nc <- nchar(x)
  n <- ceiling(nc/max_nchars)

  up <- 0
  start <- 1
  end <- max_nchars
  vec <- c()

  for (i in 1:n) {
    start <- start + up
    end <- end + up
    up <- max_nchars

    line <- stringr::str_sub(x, start = start, end = end)
    vec <- c(vec, line)
  }

  x <- paste(vec, collapse = "\n")
  x
}

# Check Functions ----

check_modal <- function(check, title = "Please fix the following issue ...") {
  msg <- gsub("^Error (.*?)( : )", "", check[1])
  msg <- gsub("Error : ", "", msg)
  modalDialog(paste(msg),
              title = title, footer = modalButton("Got it")
  )
}

## app only check ----
check_sheet_names <- function(sheets, template_sheets) {
  if (any(!(sheets %in% template_sheets))) {
    chk::abort_chk(
      "The sheet names of the uploaded file do not match the sheet names of the
      template. You need to correct the sheet names before the file will be
      uploaded to the app."
    )
  }
}




