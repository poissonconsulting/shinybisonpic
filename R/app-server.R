app_server <- function(input, output, session) {

  shinyhelper::observe_helpers(
    help_dir = system.file("helpfiles", package = "shinybisonpic")
  )

  data <- mod_upload_server(
    "mod_upload_ui"
  )

  mod_map_server(
    "mod_map_ui",
    data
  )

  mod_plot_server(
    "mod_plot_server",
    data
  )

  mod_download_server(
    "mod_download_server",
    data
  )

  mod_help_server(
    "mod_help_ui"
  )

  mod_about_server(
    "mod_about_ui"
  )

}
