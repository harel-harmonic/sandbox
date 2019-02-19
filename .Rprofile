################################
## Project's Global Variables ##
################################
## Session info
k_counter_calls <- tryCatch(k_counter_calls + 1, error = function(e) 0)
k_session_uid <- if(k_counter_calls==0) rmonic::rand_strings(1, 10) else k_session_uid
## Folder paths
k_path_project <<- tryCatch(rprojroot::find_rstudio_root_file(), error = function(e) getwd())
paths <- yaml::yaml.load_file(file.path(k_path_project, "config.yml"))[["project_folders"]]
for(k in 1:length(paths)) assign(names(paths)[k], eval(parse(text = paths[[k]])))
rm(paths, k)



#########################
## Project's Libraries ##
#########################
library(rmonic)
rmonic::load_packages(file = file.path(k_path_project, "config.yml"))


#########################
## Conflict Resolution ##
#########################
if(suppressWarnings(require(conflicted, quietly = TRUE))){
    ## Resolve conflicts - persistently prefer one function over another
    suppressMessages({
        conflict_prefer("setup", "rmonic")
        conflict_prefer("filter", "dplyr")
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
