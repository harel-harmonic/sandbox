################################
## Project's Global Variables ##
################################
## Folder paths
k_path_project <<- tryCatch(rprojroot::find_rstudio_root_file(), error = function(e) getwd())
k_path_code <<- file.path(k_path_project, "code")
k_path_data <<- file.path(k_path_project, "data")
k_path_docs <<- file.path(k_path_project, "docs")
k_path_models <<- file.path(k_path_project, "models")
k_path_scripts <<- file.path(k_path_project, "code", "scripts")
k_path_modules <<- file.path(k_path_project, "code", "modules")
k_path_functions <<- file.path(k_path_project, "code", "R")
k_path_data_raw <<- file.path(k_path_project, "data", "raw")
k_path_data_interim <<- file.path(k_path_project, "data", "interim")
k_path_data_processed <<- file.path(k_path_project, "data", "processed")
k_path_data_for_modeling <<- file.path(k_path_project, "data", "for-modeling")
k_path_data_not_for_modeling <<- file.path(k_path_project, "data", "not-for-modeling")
k_path_notebooks <<- file.path(k_path_project, "docs", "notebooks")


#########################
## Project's Libraries ##
#########################
library(rmonic)
rmonic::load_packages(file = file.path(k_path_project, "requirements.yml"))


#########################
## Project's Functions ##
#########################
rmonic::load_functions(path = k_path_functions)
