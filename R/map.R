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

  # init stuff goes here
  title_str <- htmltools::HTML(
  "<strong>Ansible Community - Meetups and Contributors</strong><br/>
       Country colour: PRs opened in the last 12 months<br/>
       Circle markers: Meetups, radius &prop; Meetup.com membership<br/>
       <em>Sources: GitHub.com and Meetup.com APIs</em>"
  )

  init_map <- leaflet(
    options = leafletOptions(zoomControl = FALSE)
  ) %>%
    addControl(title_str, position = "topleft") %>%
    setView(0, 25, 2.5) %>%
    addTiles() %>%
    addLayersControl(
      overlayGroups = c('PRs'),
      position = 'bottomleft',
      options = layersControlOptions(collapsed = FALSE)
    )

  moduleServer(id, function(input, output, session) {

    users_map <- data_prsServer("map")

    output$map <- renderLeaflet(init_map)

    observeEvent(users_map(), {
      leafletProxy("map", session) %>%
        layer_prs(pr_data = users_map())
    })

  })
}

# For testing
mapApp <- function() {
  ui <- fluidPage(mapUI('map'))
  server <- function(input,output,session) { mapServer('map') }
  shinyApp(ui, server)
}
