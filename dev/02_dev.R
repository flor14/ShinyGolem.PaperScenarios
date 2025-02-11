# Building a Prod-Ready, Robust Shiny Application.
# 
# README: each step of the dev files is optional, and you don't have to 
# fill every dev scripts before getting started. 
# 01_start.R should be filled at start. 
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
# 
# 
###################################
#### CURRENT FILE: DEV SCRIPT #####
###################################

# Engineering

## Dependencies ----
## Add one line by package you want to add as dependency
usethis::use_package( "thinkr" )
usethis::use_package( "shiny" )
usethis::use_package( "leaflet" )
usethis::use_package( "sf" )
usethis::use_package( "dplyr" )
usethis::use_package( "rnaturalearth" )
usethis::use_package( "rnaturalearthdata" )
usethis::use_package( "golem" )
usethis::use_package( "DT" )
usethis::use_package( "shinythemes" )
usethis::use_package( "plotly" )
usethis::use_package( "ggplot2" )
usethis::use_package( "tibble" )
usethis::use_package( "forcats" )
usethis::use_package( "shinycssloaders" )
usethis::use_package( "rgeos" )

## Add modules ----
## Create a module infrastructure in R/
golem::add_module( name = "name_of_module1" ) # Name of the module
golem::add_module( name = "name_of_module2" ) # Name of the module

## Add helper functions ----
## Creates ftc_* and utils_*
golem::add_fct( "helpers" ) 
golem::add_utils( "helpers" )

## External resources
## Creates .js and .css files at inst/app/www
golem::add_js_file( "script" )
golem::add_js_handler( "handlers" )
golem::add_css_file( "custom" )

## Add internal datasets ----
## If you have data in your package

usethis::use_data_raw( name = "pampa_polygon", open = FALSE ) 
usethis::use_data(pampa_polygon, overwrite = TRUE, internal = TRUE)
usethis::use_data_raw( name = "temp_80_percentiles_4d", open = FALSE ) 
usethis::use_data_raw( name = "base_tab_resultados_shiny", open = FALSE ) 
 resultados <- sf::read_sf("base_tab_resultados_shiny.shp")
 usethis::use_data(resultados, overwrite = TRUE)
## Tests ----
## Add one line by test you want to create
usethis::use_test( )
shinytest::recordTest()

# Documentation

## Vignette ----
usethis::use_vignette("ShinyGolem.PaperScenarios")
devtools::build_vignettes()

## Code coverage ----
## (You'll need GitHub there)
usethis::use_github_actions() #modifique yo
usethis::use_travis()
usethis::use_appveyor()

# You're now set! ----
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")


devtools::test()
