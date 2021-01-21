#' Shiny module for processing the PR map data, which
#' can be returned to Leaflet

#' layer_prs UI Function
#'
#' @description UI for the PR layer - currently no UI needed
#'
#' @param id Internal parameters for {shiny}.
#'
#' @noRd
layer_prsUI <- function(id) {
  ns <- NS(id)
}

#' layer_prs Server Function
#'
#' @noRd
layer_prsServer <- function(id, map) {
  moduleServer(id, function(input, output, session) {

    users_map <- data_prsServer("map")

    # Uses the `tmap` World shapefile
    data('World',package = 'tmap')

    world <- merge(World, users_map, by.x = 'name', by.y = 'country')
    world <- sf::st_transform(world,'+init=epsg:4326')

    # TODO This bins are hardcoded, that's going to break at some point...
    bins <- c(0,5,10,20,40,60,80,100)
    cols <- c('#c7e9c0','#a1d99b','#74c476','#41ab5d','#238b45','#006d2c','#00441b')
    pal <- colorBin(cols, domain = world$prs, bins = bins)

    labels <- sprintf(
      "<strong>%s</strong><br/>%g PRs",
      world$name, world$prs
    ) %>% lapply(htmltools::HTML)

    map %>%
      addPolygons(
        data = world,
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
      ) %>%
      addLegend(
        data = world,
        pal = pal,
        values = ~prs,
        group = 'PRs',
        opacity = 0.7,
        title = "PRs",
        position = "bottomright")
  })
}

# For testing
layer_prsApp <- function() {
  # Not sure how to test this yet!
}
