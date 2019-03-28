################################################################################
##                          0 Fold Cross Validation                           ##
################################################################################
#' WARNINGR:
#' Researching and backtesting is like drinking and driving.
#' Do not research under the influence of a backtest.
###########
## Setup ##
###########
rm(list=ls())
rmonic::setup()
rmonic::list_to_env(yaml::read_yaml(file.path(k_path_scripts, "0-fold-cv.yml")))
`%doing%` <- ifelse(allow_parallel, `%dopar%`, `%do%`)


################
## Load Model ##
################
## Load model_init, model_fit, model_store, model_end located in model folder
rmonic::load_model_components(model_name, k_path_models)


##########################
## Initialise the Model ##
##########################
## Prepare everything our model needs
model_init(model_name)


###############
## Run Model ##
###############
cat(crayon::bgGreen(bgCyan("\nModelling", model_name)))
# Initiate parallel socket cluster
if(allow_parallel) parallelisation_on()
## Loop over the dataset splits
K <- k <- 1
for(k in seq_len(K)) {
    cat(crayon::bgGreen("\nRunning fold", k, "out of", K))
    
    ## Update global variables
    do.call(function(k) split_num <<- k, list(k = k), envir = .GlobalEnv)
    
    ## Extract the current training set and test set from the rsample objects
    training_set <- consolidate_training_inputs(split_num)
    test_set <- consolidate_test_inputs(split_num)
    
    ## Fit model(s) to the training set
    model_fit(training_set)
    
    ## Predict the test set
    model_predict(test_set)
    
    ## Store the results for further analysis
    model_store()
}# foreach-loop

## Post-modelling operations
model_end()
if(allow_parallel) parallelisation_off()
