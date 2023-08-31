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

mod_download_ui <- function(id, label = "download") {
  ns <- NS(id)

  instructions <- bs4Dash::box(
    width = 12,
    title = shinyhelper::helper(
      div(HTML(glue::glue("Download data &nbsp &nbsp &nbsp"))),
      content = "download",
      size = "l"
    ),
    br(),
    downloadButton(ns("download_data"), "Clean Data")
  )

  fluidRow(
    column(width = 3, instructions),
    column(width = 9, uiOutput(ns("ui_table")))
  )
}


mod_download_server <- function(id, upload) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    rv <- reactiveValues(
      location = NULL,
      event = NULL,
      data = NULL
    )

    ### TODO Put in code to process data
    observe({
      rv$location <- bisonpictools::bpt_manipulate_data_analysis_location(
        upload$data$location
      )

      rv$event <- bisonpictools::bpt_manipulate_data_analysis_event(
        upload$data$event
      )

      rv$data <- list(
        event = rv$event,
        location = rv$location
      )
    })

    output$download_data <- downloadHandler(
      filename = function() {
        time_stamp <- format(Sys.time(), format = "%F %T", tz = "PST8PDT")
        time_stamp <- gsub(" ", "_", time_stamp)
        time_stamp <- gsub(":", "-", time_stamp)
        paste0(time_stamp, "_bison-data", ".xlsx")
      },
      content = function(file) {
        if (length(rv$data$event) == 0) {
          writexl::write_xlsx(upload$template_dl, file)
        } else {
          writexl::write_xlsx(rv$data, file)
        }
      }
    )

    # display data
    output$ui_table <- renderUI({
      data_tabs <- lapply(names(upload$template_dl), function(i) {
        shiny::tabPanel(
          title = i,
          wellPanel(
            DT::DTOutput(ns(glue::glue("data_table_{i}"))),
            style = "font-size:80%",
            class = "wellpanel"
          )
        )
      })
      data <- do.call(
        tabBox,
        c(
          data_tabs,
          id = ns("data_tabs"),
          width = 12,
          title = "Model ready data"
        )
      )

      tagList(data)
    })

    observe({
      lapply(names(rv$data), function(x) {
        output[[glue::glue("data_table_{x}")]] <- DT::renderDT({
          data_table(rv$data[[x]])
        })
      })
    })
  })
}
