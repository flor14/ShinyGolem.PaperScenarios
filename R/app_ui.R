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
    navbarPage(id = "navbar", 
               theme = shinythemes::shinytheme("readable"),
               "PWC Scenarios",
               tabPanel("Map", sidebarLayout(
                 sidebarPanel(
                   selectInput("polygon", "Polygon",
                               choices = unique(pampa_polygon$id_uc_gid),
                               selected = "A329_49", multiple = TRUE),
                  # tag$link("<a rel='license' href='http://creativecommons.org/licenses/by/4.0/'><img alt='Creative Commons License' style='border-width:0' src='https://i.creativecommons.org/l/by/4.0/80x15.png' /></a><br />This work is licensed under a <a rel='license' href='http://creativecommons.org/licenses/by/4.0/'>Creative Commons Attribution 4.0 International License</a>")
                 ),
                 mainPanel(
                   shinycssloaders::withSpinner(leaflet::leafletOutput("pampaPlot", 
                                                                       width = "100%"))
                 )
               )
               ),
               tabPanel("Pesticides",
                        sidebarLayout(sidebarPanel(selectInput("pesticide", 
                                                               "Pesticide",
                                                               choices = paste0("P", 1:50),
                                                               selected = "P1")), 
                                      mainPanel(
                                        shinycssloaders::withSpinner(plotly::plotlyOutput(outputId = "plot")))))

      
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
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'PWC Scenarios'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

