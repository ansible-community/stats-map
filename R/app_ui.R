#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny shinydashboard
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here
    dashboardPage(
      ui_header(),
      dashboardSidebar(disable = TRUE),
      ui_body()
    )
  )
}

#' @importFrom shinydashboard dashboardHeader
#' @noRd
ui_header <- function() {
  dashboardHeader(title = "Ansible Contributor Map")
}

#' @noRd
ui_body <- function() {
  dashboardBody(
    mod_main_ui("main_ui_1")
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'AnsibleMap'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

