#' layer_prs - Leaflet helper for rendering the PR layer, doesn't
#' need to be a Shiny module, as it's not reactive - the reactivity
#' comes from the "map" module & leafletProxy() call
#'
#' @noRd
#' @importFrom sf st_transform
layer_prs <- function(map, pr_data) {

    # Uses the `tmap` World shapefiles
    data('World', package = 'tmap')

    world <- merge(World, pr_data, by.x = 'name', by.y = 'country')
    world <- st_transform(world,'+init=epsg:4326')

    bins <- get_ranges(pr_data,7)
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
      opacity = 0.7,
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
        layerId = 'PRs',
        group = 'PRs',
        opacity = 0.7,
        title = "PRs",
        position = "bottomright")
}

#' @noRd
#' @importFrom tidyr drop_na
#' @importFrom grDevices nclass.Sturges
get_ranges <- function(pr_data, breaks = NA) {
  d <- pr_data %>% drop_na(country)

  if (is.na(breaks)) {
    breaks <- nclass.Sturges(pr_data$prs)
  }

  pretty.default(d$prs, breaks)
}
