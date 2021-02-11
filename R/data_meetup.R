#' Shiny module for processing the Meetup data, which
#' can be used by the Meetup map layer

#' data_meetup UI Function
#'
#' @description UI for the PR data - currently no UI needed
#'
#' @param id Internal parameters for {shiny}.
#'
#' @noRd
data_meetupUI <- function(id) {
  ns <- NS(id)
}

#' data_meetup Server Function
#'
#' @noRd
data_meetupServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    # Currently generated as pins from the old meetup app
    # cron jobs. TODO move to mongo storage
    pins::board_register_local(name = 'meetups', cache = '/tmp')
    pins::pin_reactive('cached_map', board = 'meetups')

  })
}

# Testing ----
data_meetupApp <- function() {
  ui <- fluidPage(
    tableOutput("data"),
    tableOutput("summary")
  )
  server <- function(input, output, session) {
    data <- data_meetupServer("data")
    output$data <- renderTable(head(data()))
    output$summary <- renderTable(
      data() %>%
        summarise(
          rows = n(),
          events = sum(Events),
          avg_members = mean(members),
          avg_rsvp = mean(RSVP)
        )
    )
  }
  shinyApp(ui, server)
}
