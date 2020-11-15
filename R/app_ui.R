#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      # Application title
     # golem::get_golem_options("mydata"),
      titlePanel("PWC Scenarios"),
      sidebarLayout(
        sidebarPanel(
          selectInput("polygon", "Polygon",
                      choices = unique(pampa_polygon$id_uc_gid),
                      selected = "A329_49", multiple = TRUE)
       ),
        
        # Show Leaflet
        mainPanel(
          leaflet::leafletOutput("pampaPlot", width = "100%")
        )
      )
    )
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
      app_title = 'ShinyGolem.PaperScenarios'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

