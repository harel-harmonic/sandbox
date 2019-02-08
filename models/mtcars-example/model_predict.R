model_predict <- function(
    # A data.frame where samples are in rows and features are in columns.
    test_set = NULL,
    # A column name which contains the identifiers of the data.frame rows.
    unique_key_column = "ROWID",
    # The result of model_fit()
    list_of_models = NULL)
{
    ###########################
    ## Defensive Programming ##
    ###########################
    ## Do not edit this part by hand
    rmonic::check_model_predict_input_arguments(test_set, unique_key_column, list_of_models)
    ## Here you may add your assertions
    
    
    ###########################################
    ## Query the Archive for Relevant Models ##
    ###########################################
    ## List the cached models 
    db_info <- 
        archivist::showLocalRepo(method = c("md5hashes","tags","sets")[2]) %>% 
        dplyr::mutate(createdDate = as.POSIXct(createdDate))
    ## Find the uids of the relevant models for this epoch 
    tags <- compose_tags(model_uid = model_uid, split = k)
    uids <- searchInLocalRepo(tags)
    ## In case there are several versions of the same model, take the latest one
    db_info <- db_info %>% 
        dplyr::filter(artifact %in% uids) %>% 
        dplyr::arrange(desc(createdDate)) %>% 
        dplyr::group_by(artifact) %>% 
        dplyr::slice(1)
    
    
    ###########
    ## Setup ##
    ###########
    ## Do not edit this part by hand
    ### Allocate list for the results
    list_of_predictions <- list()
    ### Get the number of models
    M <- nrow(db_info)
    ### Get the observations UIDs
    uid <- test_set[, unique_key_column]
    ## Here you may add your code
    
    
    ##################
    ## Calculations ##
    ##################
    ## In this part, we use a given test set and fitted model objects to produce
    ## predictions. While the prediction function (e.g. stats::predict) may vary
    ## between algorithms, the data and metadata are stored in a similar way.
    ##
    ## Each set of prediction has:
    ## (A) Prediction data (observation KEY + VALUE), stored in a data.frame
    ## (B) Prediction metadata, stored as the data.frame name
    ##
    ## Once (A) and (B) are ready, we store them in a flat list. Example:
    ## list_of_models[[metadata]] <- data
    ##
    ## Here you may remove/edit/add your code
    for(m in 1:M){
        ## Extract the fitted model object
        model_md5hash <- db_info[1 , "artifact"] %>% as.character()
        mdl_obj <- archivist::loadFromLocalRepo(model_md5hash, value = TRUE)
        ## Extract the fitted model name
        # mdl_obj <- list_of_models[[m]]
        mdl_name <- names(list_of_models)[m]
        
        ## Predict the test data on the m_th model
        response_vars <- predict(mdl_obj, test_set, interval = "predict")
        
        ## Predictions correction: mpg cannot be negative
        response_vars[response_vars < 0] <- 0
        
        ## Model output QA
        rmonic::assert_objects_have_the_same_number_of_observations(response_vars, test_set)
        if(response_vars %>% is.na() %>% any()) stop("The predictions include NA values")
        assertive::assert_all_are_non_negative(response_vars)
        
        ## Store the response variables, where each has:
        ## (A) Prediction data (observation key + value), stored in a data.frame
        ## (B) Prediction metadata, stored as the data.frame name
        for(colname in colnames(response_vars)){
            
            ## DATA: Store the predictions in a data.frame as key-value pairs
            data <- data.frame(KEY = uid, VALUE = response_vars[, colname],
                               stringsAsFactors = FALSE)
            ## METADATA: Store the predictions metadata in a valid JSON string
            metadata <- compose_model_name(mdl_name, response_type = colname)
            attr(data, "tags") <- rmonic::compose_tags(response_type = colname)
            ## Append the predicted values to the list
            list_of_predictions[[metadata]] <- data
            archivist::saveToLocalRepo(artifact = data)
            
        }# prediction-type for-loop (e.g. "fit", "lwr", "upr")
        
    }# model-wise for-loop (e.g. "mpg", "cyl", "hp")
    
    
    ############
    ## Return ##
    ############
    ## Do not edit this part by hand
    check_colnames <- function(x) assertive::assert_are_set_equal(colnames(x), c("KEY", "VALUE"))
    sapply(list_of_predictions, check_colnames)
    return(list_of_predictions)
}
