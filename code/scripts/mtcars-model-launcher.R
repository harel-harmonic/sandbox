################################################################################
##                           mtcars Model Launcher                            ##
################################################################################
#' Model Launcher Logic:
#' 1. Get the Data
#' 2. Preprocess the Data
#' 3. Split the Data
#' 4. Run Models
#' 5. Store Results
#' 
#' Prerequisites
#' 1. {rsample}
#' 2. {foreach}
#' 
#' Setup
library(rsample)
library(foreach)
library(rmonic)
setup()


######################
## Helper Functions ##
######################
#' The following functions will be defined by the team data science leader.
#' Boilerplates for these functions are created when rmonic::deploy_project is called.
#' These Boilerplates can be found under "~/code/R".
load_data_for_modeling <- function(){list(mtcars = mtcars)}
preprocess_data_for_modeling <- function(datasets_list){identity(datasets_list)}


##################
## Get the Data ##
##################
list_of_datasets <- load_data_for_modeling()


#########################
## Preprocess the Data ##
#########################
list_of_tidysets <- preprocess_data_for_modeling(list_of_datasets)


####################
## Split the Data ##
####################
dataset <- list_of_tidysets[["mtcars"]]
rset_obj <- rsample::initial_split(dataset, prop = 3/4)


####################
## Run the Models ##
####################
models_names <- c("model_001", "model_002")

results <- foreach(model_name=models_names) %do% {
    ## Load model components into global environment
    load_model(model_name)
    ## Launch model
    result <- run_model()
    ## Clean up
    rm(model_init, model_fit, model_predict, model_store, model_end)
}


#######################
## Store the Results ##
#######################
saveRDS(results, file.path(k_path_data_not_for_modeling, "models-results.RDS"))

