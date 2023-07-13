mod_map_ui <- function(id, label = "map") {

  ns <- NS(id)

  box()

}


mod_map_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {

    ns <- session$ns

  })
}
