#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {

  # world map (to plot near countries as Uruguay)
  world <- rnaturalearth::ne_countries(scale = "medium", 
                                       returnclass = "sf")
  

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
    
    db_plot <- reactive({
      
      temp_80_per_4d <- read.csv("data-raw/temp_80_percentiles_4d.csv")
      
      temp_80_per_4d %>% 
        dplyr::filter(order == input$pesticide)
      
    })
    
    years_order <- reactive({
      
      years_order <- db_plot() %>%
        dplyr::filter(rank == 6) %>%   # El que tiene orden 24 seria el 6to mayor
        dplyr::arrange(X4.day) %>% # este ultimo arrange me da el orden definitivo
        dplyr::ungroup() %>%
        # mutate(carto_unit = as_factor(carto_unit)) %>%
        .$carto_unit
      years_order
    })
    
    output$plot <- plotly::renderPlotly({ 
      
    
      ggplot <- db_plot() %>%
        ggplot2::ggplot() +
        ggplot2::geom_tile(ggplot2::aes(y = forcats::fct_relevel(carto_unit, 
                                                        levels = as.character(years_order())),
                               x = forcats::fct_rev(factor(rank)),
                               fill = X4.day),
                           width=.9, 
                           height=.8)+ # dejo espacios entre las filas
        ggplot2::geom_vline(xintercept = c(24.5, 25.5),
                            color = "blue", 
                            lwd = 0.75)+
        ggplot2::geom_hline(yintercept = c(63.5, 64.5),
                            color = "blue",
                            lwd = 0.75)+
        ggplot2::scale_fill_viridis_c(option = "A",
                                direction = -1)+
        ggplot2::labs(x = "30 years annPEC 4d (temporal component)", 
                      y = "Soil-climate combinations ranked by the 6th higher annPEC 4d (spatial component)",
                      fill = "PEC 4d (ppb)")+
        ggplot2::theme_classic(base_size = 10) 
      
      plotly::ggplotly(ggplot) %>% plotly::layout(height = 600,
                                                  width = 600)
    })
   
}
