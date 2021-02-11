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
    # We use reactivePoll to query the max timestamp of the db
    # and refresh the data if it changes

    reactivePoll(10000, session,
      checkFunc = check_mongo_timestamp,
      valueFunc = get_mongo_data
    )

  })
}

# Helpers

#' Construct a connection string to Mongo using {config}
#' @noRd
#' @importFrom glue glue
db_con <- function() {
  config_group <- ifelse(getOption('golem.app.prod'), 'prod', 'default')
  Sys.setenv(R_CONFIG_ACTIVE = config_group)
  c <- config::get()

 glue("mongodb://{c$DBUSER}:{c$DBPASS}@{c$DBHOST}:{c$DBPORT}/{c$DBNAME}")
}

#' @noRd
#' @import mongolite
#' @importFrom lubridate ymd_hms
check_mongo_timestamp <- function() {
  mongo(url = db_con(), collection = 'users')$find(
    query = '{}',
    fields = '{"_id":0, "updated_at":1}',
    sort = '{"updated_at": -1}',
    limit = 1
  ) %>% pull(1) %>% ymd_hms()
}

#' @noRd
#' @import dplyr
#' @importFrom lubridate ymd_hms
get_mongo_data <- function() {
  users <- mongo(url = db_con(), collection = 'users')$find(
    query  = '{"country": {"$ne": null} }',
    fields = '{"country":1}')

  months = as.integer(12) # make a control
  # mapreduce?
  issues <- mongo(url = db_con(), collection = 'issues')$find(
    query = '{}',
    fields = '{"author.login":1, "createdAt":1}') %>%
    mutate(
      createdAt <- ymd_hms(createdAt)
    ) %>%
    filter(createdAt > Sys.Date() - months(months))

  pulls <- mongo(url = db_con(), collection = 'pulls')$find(
    query = '{}',
    fields = '{"author.login":1, "createdAt":1}') %>%
    mutate(
      createdAt <- ymd_hms(createdAt)
    ) %>%
    filter(createdAt > Sys.Date() - months(months))

  bind_rows(
    issues %>% mutate(type = 'issue'),
    pulls  %>% mutate(type = 'pull')
  ) %>%
    mutate(author = author$login) %>%
    left_join(users,by = c('author' = '_id')) %>%
    count(country, sort= T, name = 'prs')
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
