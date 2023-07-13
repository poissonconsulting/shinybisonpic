mod_about_ui <- function(id, label = "about") {
  ns <- NS(id)

  box(
    width = 12,
    collapsible = FALSE
  )
}



mod_about_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
  })
}
