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
      div(HTML(glue::glue("Plot Ratios &nbsp &nbsp &nbsp"))),
      content = "plot"
    ),
    tags$label("Select sex-age groups to generate a ratio:"),
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
    uiOutput(ns("download_button")),
    br(), br(),
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
      denominator = NULL,
      plot = NULL
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
      rv$numerator_human <- c(
        input$select_numerator_m,
        input$select_numerator_f,
        input$select_numerator_u
      )
      rv$numerator <- code_sex_age(rv$numerator_human)
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
      rv$denominator_human <- c(
        input$select_denominator_m,
        input$select_denominator_f,
        input$select_denominator_u
      )
      rv$denominator <- code_sex_age(rv$denominator_human)
    })

    output$plot <- renderPlot({
      req(rv$event)
      req(rv$location)
      req(rv$numerator)
      req(rv$denominator)

      rv$plot <- bisonpictools::bpt_plot_ratios(
        rv$event,
        rv$location,
        numerator = rv$numerator,
        denominator = rv$denominator
      )
      rv$plot
    })

    output$ui_plot <- renderUI({
      plotOutput(ns("plot"))
    })

    output$download_button <- renderUI({
      req(rv$plot)
      downloadButton(ns("download_plot"), "Download Plot", class = "btn-plot")
    })

    output$download_plot <- downloadHandler(
      filename = "shinybisonpic_ratio_plot.png",
      content = function(file) {
        title <- add_title_newlines(
          gsub(
            "'",
            "",
            paste(
              "Ratio of",
              chk::cc(rv$numerator_human,  conj = " and ", ellipsis = 20L),
              "per",
              chk::cc(rv$denominator_human, conj = " and ", ellipsis = 20L)
            )
          )
        )

        plot <- rv$plot +
          ggplot2::ggtitle(title)

        ggplot2::ggsave(
          file,
          plot,
          device = "png",
          width = 9
        )
      }
    )

  })
}
