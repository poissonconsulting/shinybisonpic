# Copyright 2023 Province of Alberta

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
          mapply(tags$th, colnames(data), style = sprintf("border-right: solid %spx;", c(0.5, rep(0, ncol(data) - 1L))), SIMPLIFY = FALSE)
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

is_try_error <- function(x) {
  inherits(x, "try-error")
}

add_title_newlines <- function(x, max_nchars = 82) {
  nc <- nchar(x)
  n <- ceiling(nc / max_nchars)

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

check_modal <- function(check, ns, title = "Please fix the following issue ...") {
  msg <- gsub("^Error (.*?)( : )", "", check[1])
  msg <- gsub("Error : ", "", msg)
  modalDialog(
    paste(msg),
    title = title,
    footer = actionButton(ns("dismiss_modal"), label = "Got it")
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
