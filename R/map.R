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

    title_str <- htmltools::HTML(
      "<strong>Ansible Community - Meetups and Contributors</strong><br/>
       Country colour: PRs opened in the last 12 months<br/>
       Circle markers: Meetups, radius &prop; Meetup.com membership<br/>
       <em>Sources: GitHub.com and Meetup.com APIs</em>"
    )

    output$map <- renderLeaflet({
      leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
        addControl(title_str, position = "topleft") %>%
        addTiles() %>%
        layer_prsServer("map", map = .) %>%
        addLayersControl(
          overlayGroups = c("PRs"),
          position = 'bottomleft',
          options = layersControlOptions(collapsed = FALSE)
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
