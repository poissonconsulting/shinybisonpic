app_ui <- function() {
  dashboardPage(
    dark = NULL,
    scrollToTop = TRUE,
    controlbar = NULL,
    footer = NULL,
    header = dashboardHeader(
      ... = div(
        h3("Wood Bison Demographics"),
        style = "vertical-align: baseline;"
      )
    ),
    sidebar = dashboardSidebar(
      skin = "light",
      sidebarMenu(
        id = "sidebarmenu",
        menuItem(
          "Upload Data",
          tabName = "upload",
          icon = icon("upload")
        ),
        menuItem(
          "Map Locations",
          tabName = "map",
          icon = icon("map")
        ),
        menuItem(
          "Plot Data",
          tabName = "plot",
          icon = icon("chart-gantt")
        ),
        menuItem(
          "Download Data",
          tabName = "download",
          icon = icon("download")
        ),
        menuItem(
          "Help",
          tabName = "help",
          icon = icon("question")
        ),
        menuItem(
          "About",
          tabName = "about",
          icon = icon("info")
        )
      )
    ),
    body = dashboardBody(
      tabItems(
        tabItem(
          tabName = "upload",
          mod_upload_ui("mod_upload_ui")
        ),
        tabItem(
          tabName = "map",
          mod_map_ui("mod_map_ui")
        ),
        tabItem(
          tabName = "plot",
          mod_plot_ui("mod_plot_ui")
        ),
        tabItem(
          tabName = "download",
          mod_download_ui("mod_download_ui")
        ),
        tabItem(
          tabName = "help",
          mod_help_ui("mod_help_ui")
        ),
        tabItem(
          tabName = "about",
          mod_about_ui("mod_about_ui")
        )
      )
    )
  )
}
