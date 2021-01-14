#' map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' @import leaflet
mapUI <- function(id) {
  ns <- NS(id)
  tagList(
    leafletOutput(ns('map'), height = 900)
  )
}

#' map Server Function
#'
#' @noRd
#' @import leaflet
mapServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    data('World',package = 'tmap')

    # TODO make live
    um <- data.frame(
      country = World$name,
      prs = floor(runif(177,0,100))
    )

    world <- merge(World,um, by.x = 'name', by.y = 'country')
    world <- sf::st_transform(world,'+init=epsg:4326')

    # TODO This bins are hardcoded, that's going to break at some point...
    bins <- c(0,5,10,20,40,60,80,100)
    cols <- c('#c7e9c0','#a1d99b','#74c476','#41ab5d','#238b45','#006d2c','#00441b')
    pal <- colorBin(cols, domain = world$prs, bins = bins)

    labels <- sprintf(
      "<strong>%s</strong><br/>%g PRs",
      world$name, world$prs
    ) %>% lapply(htmltools::HTML)

    output$map <- renderLeaflet({
      leaflet(world,
              options = leafletOptions(zoomControl = FALSE)) %>%
        addTiles() %>%
        addPolygons(
          group = 'PRs',
          fillColor = ~pal(prs),
          weight = 2,
          opacity = 1,
          color = "grey90",
          dashArray = "3",
          fillOpacity = 0.5,
          highlight = highlightOptions(
            weight = 1,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.7,
            bringToFront = FALSE),
          label = labels,
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "15px",
            offset = c(30,0),
            direction = "right")
        )
    })
  })
}

# For testing
mapApp <- function() {
  ui <- fluidPage(mapUI('map'))
  server <- function(input,output,session) { mapServer('map') }
  shinyApp(ui, server)
}
