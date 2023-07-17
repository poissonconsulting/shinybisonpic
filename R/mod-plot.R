mod_plot_ui <- function(id, label = "plot") {

  ns <- NS(id)

  instructions <- bs4Dash::box(
    width = 12,
    tags$label("Select Plot"),
    uiOutput(ns("ui_plot_type"))
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
      event = NULL
    )

    observe({
      rv$location <- upload$data$Locations
      rv$event <- upload$data$Events
    })

    output$ui_plot_type <- renderUI({
      selectInput(
        ns("select"),
        label = NULL,
        choices = c("calf cow", "bull cow", "bull calf")
      )
    })

    output$plot <- renderPlot({
      req(rv$event)
      if (input$select == "calf cow") {
        plot(data = rv$event, fa ~ f1)
      } else if (input$select == "bull cow") {
        plot(data = rv$event, ma ~ f1)
      }
    })

    output$ui_plot <- renderUI({
      req(rv$event)
      plotOutput(ns("plot"))
    })

  })
}
