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
    br(),
    tags$label("Numerator"),
    div(
      style = "display:flex",
      uiOutput(ns("ui_select_numerator_m")),
      uiOutput(ns("ui_select_numerator_f")),
      uiOutput(ns("ui_select_numerator_u"))
    ),
    tags$label("Denominator"),
    div(
      style = "display:flex",
      uiOutput(ns("ui_select_denominator_m")),
      uiOutput(ns("ui_select_denominator_f")),
      uiOutput(ns("ui_select_denominator_u"))
    )
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
      numerator = NULL,
      denominator = NULL
    )

    observe({
      rv$location <- upload$data$location
      rv$event <- upload$data$event
    })

    output$ui_select_numerator_m <- renderUI({
      checkboxGroupInput(
        ns("select_numerator_m"),
        label = NULL,
        choices = c(
          "male calf", "male yearling", "male adult",  "male unknown",
          "male 2 yr old", "male 3 yr old"
        )
      )
    })

    output$ui_select_numerator_f <- renderUI({
      checkboxGroupInput(
        ns("select_numerator_f"),
        label = NULL,
        choices = c(
          "female calf", "female yearling", "female adult", "female unknown"
        )
      )
    })

    output$ui_select_numerator_u <- renderUI({
      checkboxGroupInput(
        ns("select_numerator_u"),
        label = NULL,
        choices = c(
          "unknown calf", "unknown yearling", "unknown adult", "unknown unknown"
        )
      )
    })

    observe({
      numerator <- c(
        input$select_numerator_m,
        input$select_numerator_f,
        input$select_numerator_u
      )
      rv$numerator <- code_sex_age(numerator)
    })

    output$ui_select_denominator_m <- renderUI({
      checkboxGroupInput(
        ns("select_denominator_m"),
        label = NULL,
        choices = c(
          "male calf", "male yearling", "male adult", "male unknown",
          "male 2 yr old", "male 3 yr old"
        )
      )
    })

    output$ui_select_denominator_f <- renderUI({
      checkboxGroupInput(
        ns("select_denominator_f"),
        label = NULL,
        choices = c(
          "female calf", "female yearling", "female adult", "female unknown"
        )
      )
    })

    output$ui_select_denominator_u <- renderUI({
      checkboxGroupInput(
        ns("select_denominator_u"),
        label = NULL,
        choices = c(
          "unknown calf", "unknown yearling", "unknown adult", "unknown unknown"
        )
      )
    })

    observe({
      denominator <- c(
        input$select_denominator_m,
        input$select_denominator_f,
        input$select_denominator_u
      )
      rv$denominator <- code_sex_age(denominator)
    })

    output$plot <- renderPlot({
      req(rv$event)
      req(rv$location)
      req(rv$denominator)
      req(rv$numerator)

      bisonpictools::bpt_plot_ratios(
        rv$event,
        rv$location,
        rv$denominator,
        rv$numerator
      )
    })

    output$ui_plot <- renderUI({

      plotOutput(ns("plot"))
    })

  })
}
