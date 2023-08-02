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
