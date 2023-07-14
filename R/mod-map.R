mod_map_ui <- function(id, label = "map") {

  ns <- NS(id)

  fluidRow(
    column(width = 12, leaflet::leafletOutput(ns("leaflet")))
  )

}


mod_map_server <- function(id, upload) {
  moduleServer(id, function(input, output, session) {

    ns <- session$ns

    rv <- reactiveValues(
      location = NULL
    )

    observe({
      print(upload$data)

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

      #|>
        # leaflet::addCircleMarkers(data = rv$location$location_id,
        #                           lng = rv$location$longitude,
        #                           lat = rv$location$latitude,
        #                           label = rv$location$location_id,
        #                           layerId = rv$location$location_id,
        #                           fill = TRUE,
        #                           radius = 4.5,
        #                           color = "#fde725"
        # )
    })






  })
}
