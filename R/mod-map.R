mod_map_ui <- function(id, label = "map") {

  ns <- NS(id)

  instructions <- bs4Dash::box(
    width = 12
  )

  fluidRow(
    column(width = 2, instructions),
    column(width = 10, leaflet::leafletOutput(ns("leaflet")))
  )


}


mod_map_server <- function(id, upload) {
  moduleServer(id, function(input, output, session) {

    ns <- session$ns


    rv <- reactiveValues(
      location = NULL
    )

    observe({
      rv$location <- upload$data$Locations
    })

    # display map
    output$leaflet <- leaflet::renderLeaflet({
      leaflet::leaflet() %>%
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

    observe({
      req(rv$location)

      proxy <- leaflet::leafletProxy(ns("leaflet"))
      proxy <- proxy |>
        leaflet::addMarkers(
          #data = rv$location$location_id,
          lng =  -114.814755, #rv$location$longitude,
          lat = 54.549608, #rv$location$latitude,
          label = "siteA", #rv$location$location_id,
          popup = "site"
        )
    })




  })
}
