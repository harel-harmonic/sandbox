model_fit <- function(training_set)
{
    ###########################
    ## Defensive Programming ##
    ###########################
    ## Do not edit this part by hand
    assertive::assert_has_rows(training_set)
    assertive::assert_all_are_existing(
        c("model_uid", "split_num", "unique_key_column", "model_archive"),
        envir = .GlobalEnv)
    ## Here you may add your assertions
    
    
    ###########
    ## Setup ##
    ###########
    # Remove the unique key column from the training set (to avoid overfitting)
    training_set <- training_set %>% select(-unique_key_column)
    # Compose the stage tag slug
    current_stage_tags <- rmonic::compose_tags(slug_model_fit, split = split_num)
    
    
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
    
    
    ###############
    ## Fit Model ##
    ###############
    model_object <- lm("MPG ~ .", training_set)
    
    
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
    model_tags <- rmonic::compose_tags(current_stage_tags, target_variable = "mpg")
    
    
    #############################
    ## Store Model in Database ##
    #############################
    rmonic::save_artifact(model_object, model_tags, model_archive)
    
    
    ############
    ## Return ##
    ############
    ## Do not edit this part by hand
    return(invisible())
}
