mod_upload_ui <- function(id, label = "upload") {

  ns <- NS(id)

  instructions <- bs4Dash::box(
    width = 12,
    title = "Upload data",
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

    shinyhelper::observe_helpers(
      help_dir = system.file("helpfiles", package = "shinybisonpic")
    )

    rv <- reactiveValues(
      data = NULL
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
    template_dl <- lapply(template_bison, function(x) {
      x$name <- NULL
      x <- x[0,]
      x
    })

    output$download_template <- downloadHandler(
      filename = "template-bison.xlsx",
      content = function(file) {
        writexl::write_xlsx(template_dl, file)
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
      #data <- set_names(data, sheets)
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



  })
}
