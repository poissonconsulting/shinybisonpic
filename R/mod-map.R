mod_map_ui <- function(id, label = "map") {

  ns <- NS(id)

  instructions <- bs4Dash::box(
    width = 12,
    title = shinyhelper::helper(
      div(HTML(glue::glue("Map Locations &nbsp &nbsp &nbsp"))),
      content = "map"
    ),
    tags$label("Highlight Location"),
    uiOutput(ns("ui_select_site"))
  )

  fluidRow(
    column(width = 2, instructions),
    column(width = 10, leaflet::leafletOutput(ns("leaflet"), height = "90vh"))
  )

}

mod_map_server <- function(id, upload) {
  moduleServer(id, function(input, output, session) {

    ns <- session$ns

    rv <- reactiveValues(
      location = NULL,
      sites = ""
    )

    observe({
      rv$location <- upload$data$Locations
    })

    observe({
      req(rv$location)
      rv$sites <- sort(unique(upload$data$Locations$location_id))
    })


    output$ui_select_site <- renderUI({
      selectInput(
        ns("select"),
        label = NULL,
        choices = rv$sites
      )
    })



    # display map
    output$leaflet <- leaflet::renderLeaflet({
      leaflet::leaflet() |>
        leaflet::addProviderTiles(
          "Esri.WorldImagery",
          options = leaflet::providerTileOptions(opacity = 1),
          group = "Satelite"
        ) |>
        leaflet::addProviderTiles(
          "CartoDB.Positron",
          options = leaflet::providerTileOptions(opacity = 1),
          group = "Open Street Map"
        ) |>
        leaflet::addLayersControl(
          baseGroups = c("Satelite", "Open Street Map"),
          options = leaflet::layersControlOptions(collapsed = FALSE),
          position = "topleft"
        ) |>
        leaflet::setView(
          lat = 54.549608,
          lng = -114.814755,
          zoom = 5,
        )
    })

    outputOptions(output, "leaflet", suspendWhenHidden = FALSE)

    observe({
      req(rv$location)

      proxy <- leaflet::leafletProxy(ns("leaflet"))
      proxy <- proxy |>
        leaflet::addCircleMarkers(
          lng =  rv$location$longitude,
          lat = rv$location$latitude,
          label = rv$location$location_id,
          fillColor = "#F1F1F1",
          color = "#F1F1F1",
          popup = leafpop::popupTable(
            as.data.frame(rv$location),
            row.numbers = FALSE
          )
        )
    })

    site_selected <- reactive({
      req(input$select)
      rv$location[rv$location$location_id == input$select, ]
    })

    observeEvent(input$select, {
      site_pick <- site_selected()

      proxy <- leaflet::leafletProxy(ns("leaflet"))
      proxy <- proxy |>
        leaflet::clearGroup("site_highlight") |>
        leaflet::addCircleMarkers(
        group = "site_highlight",
        lng =  site_pick$longitude,
        lat = site_pick$latitude,
        label = site_pick$location_id,
        fillColor = "#0070C4",
        color = "#0070C4",
        popup = leafpop::popupTable(
          as.data.frame(site_pick),
          row.numbers = FALSE
        )
      )
    })

  })
}


