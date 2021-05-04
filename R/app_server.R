#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {

  library(dplyr) # en teoria no deberia ir aca, pero tengo problemas con las pipe

  # world map (to plot near countries as Uruguay)
  world <- rnaturalearth::ne_countries(scale = "medium", 
                                       returnclass = "sf")
  

  pampa_select <- reactive({
    
    pampa_polygon %>% 
        dplyr::filter(id_uc_gid %in% input$polygon )
    
  })
  
  
  output$pampaPlot <- leaflet::renderLeaflet({ 
    
    leaflet::leaflet() %>%
      leaflet::addProviderTiles("Esri.WorldImagery") %>% 
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
    
    
    res_finales <- reactive({
      
      #elimino o 60 o 4
     res <-  resultados[,!base::names(resultados) %in% c(input$endpoint)]
      
      res %>% 
        dplyr::filter(kd_factor == input$kd) %>% 
        dplyr::group_by(carto_unit, kd_factor) %>% 
        dplyr::summarize(n = dplyr::n(), freq = round(n/45*100, digits = 2)) %>% 
        dplyr::arrange(desc(n))
    })
 
    
  
    
    
    output$pampaPlot2 <- renderPlot({
      
      pampa_elegida <- res_finales()
      
    
      
        ggplot2::ggplot()+
        ggplot2::geom_sf(data= world, 
                fill= "grey85", colour ="gray5") +
        ggplot2::geom_sf(data = pampa_polygon,
                colour = "black", fill = "grey50", size = 1) +
        #  ggplot2::geom_sf(data = pampa_cent_poly,
                # colour = "grey5", fill = "antiquewhite2", size = 1.5) +
        ggplot2::geom_sf(data = pampa_elegida,
                colour = "black", ggplot2::aes(fill = n), size = 1) +
        # ggplot2::geom_sf_label(data = pampa_elegida, 
        #                        ggplot2::aes(label = carto_unit), size = 3, 
        #                        label.padding = ggplot2::unit(0.5, "lines") )+
        
        ggplot2::scale_fill_viridis_c() +
        ggplot2::coord_sf(xlim = c(-66.25,-56), ylim = c(-40,-29.5))+
        ggplot2::ylab("Latitude")+
        ggplot2::xlab("Longitude")+
       
        ggplot2::theme_bw()+
        ggplot2::theme( panel.background = ggplot2::element_rect(fill = "#9AC5E3",
                                               colour = "#9AC5E3"),
               
               panel.border= ggplot2::element_blank(),
               panel.grid.major= ggplot2::element_blank(),
               panel.grid.minor= ggplot2::element_blank()) 
      #  ggplot2::guides(fill= ggplot2::guide_legend(title = NULL )) 
      
      
      
    })
    
    
    output$tabla <- DT::renderDataTable({
     
      sf::st_drop_geometry(res_finales())
      
    })
   
}
