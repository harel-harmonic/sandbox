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
model_name <- "mtcars-example"
## Define the dataset's primary key - a column which uniquely identifies each row
unique_key_column <- "ROWID"


####################
## Load Libraries ##
####################
## Load libraries which are not included in "~/requirements.yml"
library(lubridate)


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
rset_obj <- load_data_for_modelling()


###############
## Run Model ##
###############
## Find out how many splits the rsample object contains
K <- rmonic::get_rsample_num_of_splits(rset_obj)

## Prepare everything our model needs
model_init(model_name)

## Loop over the dataset batches
results_list <- list()
for(k in 1:K) {
    ## Extract the current training set and test set from the rsample object
    training_set <- rmonic::get_rsample_training_set(rset_obj, k)
    test_set <- rmonic::get_rsample_test_set(rset_obj, k)

    ## Fit model(s) to the training set
    list_of_models <- model_fit(training_set,
                                unique_key_column = unique_key_column,
                                model_uid = model_uid,
                                # Extra input argument for model_fit
                                split_num = k,
                                parameters = model_yaml[["parameters"]])

    ## Predict the test set
    list_of_predictions <- model_predict(test_set,
                                         unique_key_column = unique_key_column,
                                         list_of_models)

    ## Store the results for further analysis
    list_of_tables <- model_store(list_of_predictions, list_of_models)

    ## Accumulate the results
    results_list <- rmonic::bind_lists(results_list, list_of_tables)
}# foreach-loop

## Post-modelling operations
results_df <- model_end(list_of_tables = results_list, model_name = model_name)
