#' main UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList tags
mainUI <- function(id) {
  ns <- NS(id)
  tagList(
    mapUI(ns("map_1"))
  )
}

#' main Server Function
#'
#' @noRd
mainServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    # init stuff goes here

    mapServer("map_1")
  })
}
