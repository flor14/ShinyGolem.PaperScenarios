#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {

  # world map (to plot near countries as Uruguay)
  world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")
  

  pampa_select <- reactive({
    
    pampa_polygon %>% 
        dplyr::filter(id_uc_gid %in% input$polygon )
    
  })
  
  
  output$pampaPlot <- leaflet::renderLeaflet({ 
    
    leaflet::leaflet() %>%
      leaflet::addPolygons(data = world,
                  color = "#444444",
                  weight = 1, 
                  smoothFactor = 0.5,
                  opacity = 1.0, 
                  fillOpacity = 0.5,
                  highlightOptions = leaflet::highlightOptions(color = "blue", 
                                                      weight = 2)) %>% 
      leaflet::addPolygons(data= pampa_polygon,
                  weight = 1, 
                  smoothFactor = 0.5,
                  opacity = 1.0, 
                  fillOpacity = 0.5,
                  highlightOptions = leaflet::highlightOptions(color = "white", 
                                                      weight = 2,
                                                      bringToFront = TRUE)) %>%
      leaflet::addPolygons(data= pampa_select(),
                  color = "pink", 
                  weight = 1, 
                  smoothFactor = 0.5,
                  opacity = 1.0, 
                  fillOpacity = 1,
                  highlightOptions = leaflet::highlightOptions(color = "red", 
                                                      weight = 2,
                                                      bringToFront = TRUE)) %>%
      leaflet::fitBounds( -66,-30, -56, -40) 
    
    
  })
}
