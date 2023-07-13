mod_plot_ui <- function(id, label = "plot") {

  ns <- NS(id)

  box()

}


mod_plot_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {

    ns <- session$ns

  })
}
