model_fit <- function(
    # A data.frame where samples are in rows and features are in columns.
    training_set = NULL,
    # A column name which contains the identifiers of the data.frame rows.
    unique_key_column = "ROWID",
    # The model unique identifier. e.g. "u5NAm4bNl5cMIOUXZMQe".
    # Note: This information is available in config.yml.
    model_uid)
{
    ###########################
    ## Defensive Programming ##
    ###########################
    ## Do not edit this part by hand
    rmonic::check_model_fit_input_arguments(training_set, unique_key_column, model_uid)
    ## Here you may add your assertions
    assertive::assert_all_are_existing(c("split_num"), envir = .GlobalEnv)
    
    
    ###########
    ## Setup ##
    ###########
    ## Do not edit this part by hand
    ### Allocate a list for the results
    list_of_models <- list()
    ### Remove the unique key column from the training set (to avoid overfitting)
    training_set <- training_set %>% select(-unique_key_column)
    ## Here you may add your code
    
    
    #########################
    ## Note for Developers ##
    #########################
    ##
    ## The prediction process, contains at least the following three parts:
    ## 1. Compose model metadata and store it in a JSON format
    ## 2. Fit model to the training data
    ## 3. Store the model and its metadata in a flat list
    ##
    ## Often, more than one model are created. If this is the case, you may:
    ## 1. Find a for loop a convenient implementation
    ## 2. Change the order of the aforementioned parts to suit your needs
    ##
    
    
    ################################################
    ## Composing Metadata for the Model Fit Phase ##
    ################################################
    ##
    ## The following is a description of how to compose informative and valid
    ## metadata that describe model_fit outcome:
    ##
    ## 1. Metadata that extends the information available in the config.yml file
    ##    is passed via the model name. Examples for additional information are:
    ## (a) Split number. If some sampling schema is employed, say K-fold CV or
    ##     bootstrap, the split number alleviates post-processing operations.
    ## (b) The target variable (in case the same dataset has more than one
    ##     target variables, say predicting precipitation and wind-speed).
    ## (c) Grouping variables (in case the dataset is grouped by some variable,
    ##     say region).
    ##
    ## 2. Guidelines for composing a model name:
    ## (a) For the purpose of associating between a set of prediction and the
    ##     model which created it model_uid must be part of the model name.
    ## (b) The location of the different components in the name doesn't matter.
    ## (c) Each metadata must be a key-value pair. See details in
    ##     help(compose_model_name).
    ##
    mdl_mpg_name <- rmonic::compose_model_name(model_uid = model_uid,
                                               target_variable = "mpg",
                                               split = split_num) 
    mdl_mpg_name <- mdl_mpg_name %>% rmonic::standardize_json_strings()
    
    
    ###############
    ## Fit Model ##
    ###############
    mdl_mpg_obj <- lm("MPG ~ .", training_set)
    
    
    ################################
    ## Store Model in a Flat List ##
    ################################
    # saveToLocalRepo(model, repoDir, userTags = c("my_model", "do not delete"))
    # attr(x, "tags" ) = c( "name1", "name2" )
    archivist::saveToLocalRepo(artifact = mdl_mpg_obj)
    list_of_models[[mdl_mpg_name]] <- mdl_mpg_obj
    
    
    ############
    ## Return ##
    ############
    ## Do not edit this part by hand
    return(list_of_models)
}
