#' Shiny module for processing the PR input data, which
#' can be used by the PRs map layer

#' data_prs UI Function
#'
#' @description UI for the PR data - currently no UI needed
#'
#' @param id Internal parameters for {shiny}.
#'
#' @noRd
data_prsUI <- function(id) {
  ns <- NS(id)
}

#' data_prs Server Function
#'
#' @noRd
data_prsServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    # Can some of this be pre-loaded?
    # Is /tmp sensible? Should it be app-level config?
    pins::board_register_local(name = 'maps', cache = '/tmp')

    pins::pin_reactive('users_by_country', 'maps')
  })
}

# For testing
data_prsApp <- function() {
  ui <- fluidPage(
    tableOutput("data")
  )
  server <- function(input, output, session) {
    data <- data_prsServer("data")
    output$data <- renderTable(head(data()))
  }
  shinyApp(ui, server)
}
