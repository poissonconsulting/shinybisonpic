app_ui <- function() {
  dashboardPage(
    dark = NULL,
    help = NULL,
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
      css_styling(),
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
    ),
    freshTheme = fresh::create_theme(
      fresh::bs4dash_layout(main_bg = "#d1d4d3"),
      fresh::bs4dash_sidebar_light(
        bg = "#d1d4d3",
        submenu_bg = "#d1d4d3"
      ),
      fresh::bs4dash_status(
        primary = "#0081ab",
        light = "#d1d4d3"
      )
    )
  )
}
