# Building a Prod-Ready, Robust Shiny Application.
# 
# README: each step of the dev files is optional, and you don't have to 
# fill every dev scripts before getting started. 
# 01_start.R should be filled at start. 
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
# 
# 
########################################
#### CURRENT FILE: ON START SCRIPT #####
########################################

## Fill the DESCRIPTION ----
## Add meta data about your application
golem::fill_desc(
  pkg_name = "ShinyGolem.PaperScenarios", # The Name of the package containing the App 
  pkg_title = "Suplementary material - Shiny app", # The Title of the package containing the App 
  pkg_description = "Shiny app generated as supplementary material to the paper 'Statistically-based soil-climate exposure scenarios for aquatic pesticide fate modelling and exposure assessment in the Pampa Region of Argentina'", # The Description of the package containing the App 
  author_first_name = "Florencia", # Your First Name
  author_last_name = "D'Andrea",  # Your Last Name
  author_email = "florencia.dandrea@gmail.com",      # Your Email
  repo_url = "https://github.com/flor14/ShinyGolem.PaperScenarios.git" # The (optional) URL of the GitHub Repo
)
     

## Set {golem} options ----
golem::set_golem_options()

## Create Common Files ----
## See ?usethis for more information
usethis::use_mit_license( name = "Florencia D'Andrea" )  # You can set another license here
usethis::use_readme_rmd( open = FALSE )
usethis::use_code_of_conduct()
usethis::use_lifecycle_badge( "Experimental" )
usethis::use_news_md( open = FALSE )

## Use git ----
usethis::use_git()

## Init Testing Infrastructure ----
## Create a template for tests
golem::use_recommended_tests()

## Use Recommended Packages ----
golem::use_recommended_deps()

## Favicon ----
# If you want to change the favicon (default is golem's one)
golem::remove_favicon()
golem::use_favicon("inst/app/www/favicon.png") # path = "path/to/ico". Can be an online file. 
# favicon(ico = "favicon", rel = "shortcut icon",
#         resources_path = "www", ext = "png")

## Add helper functions ----
golem::use_utils_ui()
golem::use_utils_server()

# You're now set! ----

# go to dev/02_dev.R
rstudioapi::navigateToFile( "dev/02_dev.R" )

