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

    # Uses the `tmap` World shapefile for generating country data
    # Will be replaced by real data soon
    data('World',package = 'tmap')

    # return value
    # TODO make live, this is hardcoded random data
    data.frame(
      country = World$name,
      prs = floor(runif(177,0,100))
    )
  })
}

# For testing
data_prsApp <- function() {
  # Not sure how to test this yet!
}
