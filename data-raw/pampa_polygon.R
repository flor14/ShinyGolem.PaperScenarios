## code to prepare `pampa_polygon` dataset goes here
pampa_polygon <- sf::st_read("pampa_polygon.shp")
usethis::use_data(pampa_polygon, overwrite = TRUE)
