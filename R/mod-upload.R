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

mod_upload_ui <- function(id, label = "upload") {

  ns <- NS(id)

  instructions <- bs4Dash::box(
    width = 12,
    title = shinyhelper::helper(
      div(HTML(glue::glue("Upload data &nbsp &nbsp &nbsp"))),
      content = "upload"
    ),
    br(),
    tags$label("1. Download template"), br(),
    downloadButton(ns("download_template"), "XLSX"),
    br(), br(),
    tags$label("2. Upload data as XLSX file"),
    uiOutput(ns("upload_bison"))
  )

  fluidRow(
    column(width = 4, instructions),
    column(width = 8, uiOutput(ns("ui_table")))
  )

}


mod_upload_server <- function(id) {
  moduleServer(id, function(input, output, session) {

    ns <- session$ns

    rv <- reactiveValues(
      data = NULL,
      template_dl = NULL
    )

    # read in template
    path <- system.file(
      package = "shinybisonpic",
      "app/www/template-bison.xlsx"
    )
    sheets <- readxl::excel_sheets(path)
    template_bison <- lapply(sheets, function(x) readxl::read_excel(path, x))
    names(template_bison) <- sheets

    # download template
    observe({
      template_dl <- lapply(template_bison, function(x) {
        x$name <- NULL
        x <- x[0,]
        x
      })

      rv$template_dl <- template_dl
    })


    output$download_template <- downloadHandler(
      filename = "template-bison.xlsx",
      content = function(file) {
        writexl::write_xlsx(rv$template_dl, file)
      }
    )

    # upload data widget
    output$upload_bison <- renderUI({
      fileInput(
        ns("upload"),
        label = NULL,
        accept = c(".xlsx")
      )
    })

    # create template and data tabs
    output$ui_table <- renderUI({
      template_tabs <- lapply(sheets, function(i) {
        shiny::tabPanel(
          title = i,
          wellPanel(
            DT::DTOutput(ns(glue::glue("template_table_{i}"))),
            style = "font-size:80%",
            class = "wellpanel"
          )
        )
      })
      templates <- do.call(
        tabBox,
        c(
          template_tabs,
          id = ns("template_tabs"),
          width = 12,
          title = "Required data format"
        )
      )

      upload_tabs <- lapply(sheets, function(i) {
        shiny::tabPanel(
          title = i,
          wellPanel(
            DT::DTOutput(ns(glue::glue("upload_table_{i}"))),
            style = "font-size:85%",
            class = "wellpanel"
          )
        )
      })
      uploads <- do.call(
        tabBox,
        c(
          upload_tabs,
          id = ns("upload_tabs"),
          width = 12,
          title = "Uploaded data"
        )
      )
      tagList(templates, uploads)
    })

    # display template
    observe({
      template_mod <- lapply(template_bison, template_human)
      lapply(sheets, function(x) {
        output[[glue::glue("template_table_{x}")]] <- DT::renderDT({
          template_table(template_mod[[x]])
        })
      })
    })

    # create and display uploaded data
    observeEvent(input$upload, {
      ### TODO checks
      sheets <- readxl::excel_sheets(input$upload$datapath)
      data <- lapply(sheets, function(x) {
        readxl::read_excel(input$upload$datapath, sheet = x, na = c("", "NA"))
      })
      names(data) <- sheets
      rv$data <- data
      ### TODO checks
      rv$data <- data
    }, label = "generating data")

    observe({
      lapply(names(rv$data), function(x) {
        output[[glue::glue("upload_table_{x}")]] <- DT::renderDT({
          data_table(rv$data[[x]])
        })
      })
    })

    return(rv)

  })
}
