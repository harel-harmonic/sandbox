##############################
## Project Global Variables ##
##############################
## Session info
k_counter_calls <- tryCatch(k_counter_calls + 1, error = function(e) 0)
k_session_uid <- if(k_counter_calls==0) rmonic::rand_strings(1, 10) else k_session_uid


#####################
## Project Folders ##
#####################
if(!require(yaml, quietly = TRUE)) install.packages("yaml")
k_path_project <<- tryCatch(rprojroot::find_rstudio_root_file(), error = function(e) getwd())
config_file_path <- file.path(k_path_project, "config.yml")
for(k_path in yaml::yaml.load_file(config_file_path)$project_paths) eval(parse(text = k_path))


#######################
## Project Functions ##
#######################
rmonic::load_functions(path = k_path_functions)


######################
## Packages Manager ##
######################
config_file_path <- file.path(k_path_project, "config.yml")
project_config <- yaml::yaml.load_file(config_file_path)
## Get package management configurations
rmonic::list_to_env(project_config)
## Install packages
flag_checkpoint <-
    "checkpoint" %in% packages_management[["agent"]] &
    packages_management[["activated"]] &
    k_counter_calls == 0
if(flag_checkpoint)
    checkpoint(packages_management[["snapshot_date"]],packages)
## Load packages
rmonic::load_packages(file = config_file_path)


#########################
## Conflict Resolution ##
#########################
if(suppressWarnings(require(conflicted, quietly = TRUE))){
    ## Resolve conflicts - persistently prefer one function over another
    suppressMessages(rmonic::yaml_to_execute(config_file_path, "packages_conflicts"))
    ## Show conflicts on startup
    if(k_counter_calls == 0) conflicted::conflict_scout()
}


##############
## Clean-up ##
##############
suppressWarnings(rm(config_file_path, flag_checkpoint))
