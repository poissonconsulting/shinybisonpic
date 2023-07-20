mod_help_ui <- function(id, label = "help") {
  ns <- NS(id)

  box(
    width = 12,
    collapsible = FALSE,
    includeMarkdown(system.file(package = "shinybisonpic", "helpfiles/help.md"))
  )
}



mod_help_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
  })
}
