model_store <- function(
    # The output of model_predict()
    list_of_predictions,
    # The output of model_fit()
    list_of_models){
    ###########################
    ## Defensive Programming ##
    ###########################
    ## Do not edit this part by hand
    rmonic::check_model_store_input_arguments(list_of_predictions, list_of_models)
    ## Here you may add your assertions
    
    
    ################
    ## Store Data ##
    ################
    ## Parse the prediction models data
    PREDICTIONS_DATA <- rmonic::store_predictions_data(list_of_predictions)
    ## Parse the prediction models metadata
    PREDICTIONS_METADATA <- rmonic::store_predictions_metadata(list_of_predictions)
    ## Parse the prediction models data
    MODELS_DATA <- rmonic::store_models_data(list_of_predictions)
    ## Parse the prediction models metadata
    MODELS_METADATA <- rmonic::store_models_metadata(list_of_predictions)
    
    
    ############
    ## Return ##
    ############
    list_of_tables <- list(PREDICTIONS_DATA = PREDICTIONS_DATA,
                           PREDICTIONS_METADATA = PREDICTIONS_METADATA,
                           MODELS_DATA = MODELS_DATA,
                           MODELS_METADATA = MODELS_METADATA)
    return(list_of_tables)
}
