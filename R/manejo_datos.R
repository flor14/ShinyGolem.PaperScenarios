
# estos resultados pueden ser una cantidad variable entradas por uc, 
# ya que son la sunidades que caen dentro de los percentiles definidos.

res60 <- read.csv("C:/Users/FLORENCIA/Dropbox/paper_escenarios/EscenariosCompendio/filtrado809090_X60.csv") %>% 
  dplyr::select(order, carto_unit, pesticide, kd.1, "values_60" = values)

res4 <- read.csv("C:/Users/FLORENCIA/Dropbox/paper_escenarios/EscenariosCompendio/filtrado809090_X4.csv") %>% 
  dplyr::select(order, carto_unit, pesticide, kd.1, "values_4" = values )

base_triple <- read.delim(sep = " ", "C:/Users/FLORENCIA/Dropbox/pwc_repositorio_final/archivos/generacion_databases/base_triple.txt") %>% 
  tibble::as_tibble() %>% 
  dplyr::select(id_uc_gid, ZonaORA,SNAM, HYDGRP )



freq_4_60 <- tibble::as_tibble(dplyr::left_join(res4, res60)) %>% # aparecen NAs en la base de datos de 60 ya que hay menos valores
  dplyr::left_join(base_triple, by = c("carto_unit" = "id_uc_gid")) 

freq_4_60 <- freq_4_60 %>% 
  dplyr::mutate( kd_factor = cut(kd.1, breaks = c(0, 3, 50, max(freq_4_60$kd.1))) ) %>% 
  dplyr::left_join(pampa_polygon, by = c("carto_unit" = "id_uc_gid"))
  
sf::write_sf(freq_4_60, "base_tab_resultados_shiny.shp")

# freq_4_60 %>% View()
# dplyr::select(-values_60) %>% 
#  count(carto_unit, sort = TRUE)
# 
# freq_4_60 %>% 
#   select(-values_4) %>% 
#   count(carto_unit, sort = TRUE)
