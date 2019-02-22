################################################################################
##                             Model Backtesting                              ##
################################################################################
#' WARNINGR:
#' Researching and backtesting is like drinking and driving.
#' Do not research under the influence of a backtest.
rmonic::setup()


####################
## Configurations ##
####################
## Define the model's name (must be identical to the model folder's name)
model_name <<- "mtcars-example"


################
## Load Model ##
################
## Load model_init, model_fit, model_store, model_end located in model folder
rmonic::load_model_components(model_name, k_path_models)
## Load model helper functions located in model folder under helper-functions
rmonic::load_model_helper_functions(model_name, k_path_models)


#############################
## Load Data for Modelling ##
#############################
## Extract the data source details into global environment
model_yaml <- rmonic::load_model_metadata(model_name, k_path_models)
list2env(model_yaml[["data_source"]], envir = .GlobalEnv)
## Get the data
rset_obj <- load_data_for_modelling()


###############
## Run Model ##
###############
## Find out how many splits the rsample object contains
K <- rmonic::get_rsample_num_of_splits(rset_obj)

## Prepare everything our model needs
model_init(model_name)

## Loop over the dataset batches
list_of_bind_tables <- list()
for(k in 1:K) {
    ## Update global variables
    split_num <<- k

    ## Extract the current training set and test set from the rsample object
    training_set <- rmonic::get_rsample_training_set(rset_obj, k)
    test_set <- rmonic::get_rsample_test_set(rset_obj, k)

    ## Fit model(s) to the training set
    model_fit(training_set)

    ## Predict the test set
    model_predict(test_set)

    ## Store the results for further analysis
    model_store()
}# foreach-loop

## Post-modelling operations
model_end()
