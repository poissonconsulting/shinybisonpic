#Copyright 2023 Province of Alberta

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

app_ui <- function() {
  dashboardPage(
    dark = NULL,
    help = NULL,
    scrollToTop = TRUE,
    controlbar = NULL,
    footer = NULL,
    header = dashboardHeader(
      ... = div(
        h3("Ronald Lake Wood Bison Camera-Based Demographic Model"),
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
      fresh::bs4dash_layout(main_bg = "#F1F1F1"),
      fresh::bs4dash_sidebar_light(
        bg = "#F1F1F1",
        submenu_bg = "#F1F1F1"
      ),
      fresh::bs4dash_status(
        primary = "#0070C4",
        light = "#FEBA35"
      )
    )
  )
}
