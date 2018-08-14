################################################################################
#                                     Main                                     #
################################################################################
#' GitHub webpage
#' <https://ropensci.github.io/drake/>
#' 
#' The drake R Package User Manual
#' <https://ropenscilabs.github.io/drake-manual/index.html#the-drake-r-package>
#' 
#####################
# Inputs validation #
#####################
k_path_project <<- rprojroot::find_rstudio_root_file()
source(file.path(k_path_project, "code", "scripts", "setup.R"))
#'
#######
# ??? #
#######
# Import flu datasets
messy_datasets <- import_flu_datasets()