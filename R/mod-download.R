mod_download_ui <- function(id, label = "download") {

  ns <- NS(id)

  box()

}


mod_download_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {

    ns <- session$ns

  })
}
