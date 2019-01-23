################################################################################
##                             Model Backtesting                              ##
################################################################################
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


#############################
## Load Data for Modelling ##
#############################
rset_obj <- load_data_for_modelling()


#############################
## Load Model's Components ##
#############################
load_model(model_name, k_path_models)


###############
## Run Model ##
###############
## Find out how many splits the rsample object contains
K <- rmonic::get_rsample_num_of_splits(rset_obj)

## Prepare everything our model needs
model_init(model_name)

## Loop over the dataset batches
results_list <- foreach(k = 1:K, .combine = rmonic::bind_lists) %do% {
    ## Extract the current training set and test set from the rsample object
    training_set <- rmonic::get_rsample_training_set(rset_obj, k)
    test_set <- rmonic::get_rsample_test_set(rset_obj, k)

    ## Fit model(s) to the training set
    list_of_models <- model_fit(training_set,
                                unique_key_column = unique_key_column,
                                model_uid = model_yaml[["model_uid"]],
                                # Extra input argument for model_fit
                                split_num = k,
                                parameters = model_yaml[["parameters"]])

    ## Predict the test set
    list_of_predictions <- model_predict(test_set,
                                         unique_key_column = unique_key_column,
                                         list_of_models)

    ## Store the results for further analysis
    list_of_tables <- model_store(list_of_predictions, list_of_models)
}# foreach-loop

## Post-modelling operations
results_df <- model_end(results_list)
