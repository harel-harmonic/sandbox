################################################################################
#                                    Setup                                     #
################################################################################
#' Clear the environment
# rm(list = ls()) # remove all variables from global environment
cat("\014") # clear the screen
message("#########\n# SETUP #\n#########")
#' Validate that the project path exists
stopifnot(exists("k_path_project"))
#'
##########################
# Define project's paths #
##########################
# k_path_project <<- rprojroot::find_rstudio_root_file()
k_path_scripts <<- file.path(k_path_project, "code", "scripts")
k_path_modules <<- file.path(k_path_project, "code", "modules")
k_path_functions <<- file.path(k_path_project, "code", "R")
k_path_data_raw <<- file.path(k_path_project, "data", "raw")
k_path_data_processed <<- file.path(k_path_project, "data", "processed")
k_path_documents <<- file.path(k_path_project, "docs")
#'
############################
# Load project's functions #
############################
source(file.path(k_path_modules, "setup", "load_project_functions.R"))
#' Load project's functions
message("-> ", "Loading project's functions")
load_project_functions()
#'
#' Load project's parameters
message("-> ", "Loading project's parameters")
load_project_parameters()
#'
#' Load project's libraries
message("-> ", "Loading project's libraries")
load_project_libraries()
#'
#' Performs various substitutions in all .R files
# message(paste0(rep("#",80), collapse=""), "\n# Prettifying the project's code\n", paste0(rep("#",80), collapse=""))
# styler::style_dir(k_path_project,
#                   exclude_files = file.path(k_path_project, "code", "data-pipeline.R"))
#'
#' Generate session ID
UID <- stringi::stri_rand_strings(n = 1, length = 20)
