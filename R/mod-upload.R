mod_upload_ui <- function(id, label = "upload") {

  ns <- NS(id)

  box()

}


mod_upload_server <- function(id) {
  moduleServer(id, function(input, output, session) {

    ns <- session$ns

  })
}
