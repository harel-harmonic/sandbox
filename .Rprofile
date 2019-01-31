################################
## Project's Global Variables ##
################################
## Session info
k_counter_calls <- tryCatch(k_counter_calls + 1, error = function(e) 0)
k_session_uid <- if(k_counter_calls==0) rmonic::rand_strings(1, 10) else k_session_uid
## Folder paths
k_path_project <<- tryCatch(rprojroot::find_rstudio_root_file(), error = function(e) getwd())
k_path_code <<- file.path(k_path_project, "code")
k_path_data <<- file.path(k_path_project, "data")
k_path_docs <<- file.path(k_path_project, "docs")
k_path_models <<- file.path(k_path_project, "models")
k_path_modules <<- file.path(k_path_project, "code", "modules")
k_path_functions <<- file.path(k_path_project, "code", "R")
k_path_scripts <<- file.path(k_path_project, "code", "scripts")
k_path_tests <<- file.path(k_path_project, "code", "tests")
k_path_data_raw <<- file.path(k_path_project, "data", "raw")
k_path_data_interim <<- file.path(k_path_project, "data", "interim")
k_path_data_processed <<- file.path(k_path_project, "data", "processed")
k_path_data_for_modeling <<- file.path(k_path_project, "data", "for-modeling")
k_path_data_not_for_modeling <<- file.path(k_path_project, "data", "not-for-modeling")
k_path_submissions <<- file.path(k_path_project, "data", "submissions")
k_path_notebooks <<- file.path(k_path_project, "docs", "notebooks")
k_path_reports <<- file.path(k_path_project, "docs", "reports")
k_path_archive_local <<- file.path(k_path_project, "data", "archive")
k_path_archive_shared <<- file.path(k_path_project, "data", "archive")


#########################
## Project's Libraries ##
#########################
library(rmonic)
rmonic::load_packages(file = file.path(k_path_project, "requirements.yml"))


#########################
## Conflict Resolution ##
#########################
if(suppressWarnings(require(conflicted, quietly = TRUE))){
    ## Resolve conflicts - persistently prefer one function over another
    suppressMessages({
        conflict_prefer("filter", "dplyr")
        conflict_prefer("setup", "rmonic")
        conflict_prefer("union", "dplyr")
        conflict_prefer("setdiff", "dplyr")
        conflict_prefer("intersect", "dplyr")
    })
    ## Show conflicts on startup
    if(k_counter_calls == 0) conflicted::conflict_scout()
}


#########################
## Project's Functions ##
#########################
rmonic::load_functions(path = k_path_functions)
