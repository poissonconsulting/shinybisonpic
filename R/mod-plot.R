mod_plot_ui <- function(id, label = "plot") {

  ns <- NS(id)

  instructions <- bs4Dash::box(
    width = 12,
    title = shinyhelper::helper(
      div(HTML(glue::glue("Plot Data &nbsp &nbsp &nbsp"))),
      content = "plot"
    ),
    tags$label("Select Plot"),
    uiOutput(ns("ui_select_sex")),
    uiOutput(ns("ui_select_age"))
  )

  plot <- bs4Dash::box(
    width = 12,
    title = "Plots",
    uiOutput(ns("ui_plot"))
  )

  fluidRow(
    column(width = 4, instructions),
    column(width = 8, plot)
  )

}

mod_plot_server <- function(id, upload) {
  moduleServer(id, function(input, output, session) {

    ns <- session$ns

    rv <- reactiveValues(
      location = NULL,
      event = NULL,
      select = NULL
    )

    observe({
      rv$location <- upload$data$Locations
      rv$event <- upload$data$Events
    })

    output$ui_select_sex <- renderUI({
      checkboxGroupInput(
        ns("select_sex"),
        label = "Sex",
        choices = c("male", "female", "unknown"),
        inline = TRUE
      )
    })

    output$ui_select_age <- renderUI({
      checkboxGroupInput(
        ns("select_age"),
        label = "Age",
        choices = c(
          "calf", "yearling",  "adults", "2 yr olds (male only)",
          "3 yr olds (males only)", "unknown"
        ),
        inline = TRUE
      )
    })

    observe({
      rv$select <- c(input$select_age, input$select_sex)
    })

    output$plot <- renderPlot({
      req(rv$event)
      req(rv$select)
      if (c("unknown") %in% rv$select) {
        plot(data = rv$event, fa ~ f1)
      } else if ("yearling" %in% rv$select) {
        plot(data = rv$event, ma ~ f1)
      }
    })

    output$ui_plot <- renderUI({
      req(rv$event)
      plotOutput(ns("plot"))
    })

  })
}
