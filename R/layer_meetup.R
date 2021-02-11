#' layer_meetup - Leaflet helper for rendering the Meetup layer,
#' doesn't need to be a Shiny module, as it's not reactive - the
#' reactivity comes from the "map" module & leafletProxy() call
#'
#' @noRd
layer_meetup <- function(map, meetup_data) {

  # preprocess code here
  scale_factor_m = 25 * 1 / max(sqrt(meetup_data$members))
  em = mutate(meetup_data, tooltip2 = paste(sep = '<br/>', tooltip, paste0('Members:',members)))

  # update the map
  addCircleMarkers(
    map = map,
    data = em,
    group = 'Meetups',
    popup = ~as.character(tooltip2),
    radius = ~sqrt(members)*scale_factor_m,
    stroke = FALSE,
    fillOpacity = 0.5)
}

# Helpers ----
