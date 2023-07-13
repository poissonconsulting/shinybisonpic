mod_help_ui <- function(id, label = "help") {
  ns <- NS(id)

  box(
    width = 12,
    collapsible = FALSE
  )
}



mod_help_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
  })
}
