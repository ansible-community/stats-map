#' layer_prs - Leaflet helper for rendering the PR layer, doesn't
#' need to be a Shiny module, as it's not reactive - the reactivity
#' comes from the "map" module & leafletProxy() call
#'
#' @noRd
layer_prs <- function(map, pr_data) {

    # Uses the `tmap` World shapefiles
    data('World',package = 'tmap')

    world <- merge(World, pr_data, by.x = 'name', by.y = 'country')
    world <- sf::st_transform(world,'+init=epsg:4326')

    # TODO This bins are hardcoded, that's going to break at some point...
    bins <- c(0,5,10,20,40,60,80,100)
    cols <- c('#c7e9c0','#a1d99b','#74c476','#41ab5d','#238b45','#006d2c','#00441b')
    pal <- colorBin(cols, domain = world$prs, bins = bins)

    labels <- sprintf(
      "<strong>%s</strong><br/>%g PRs",
      world$name, world$prs
    ) %>% lapply(htmltools::HTML)

    addPolygons(
      map = map,
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
}
