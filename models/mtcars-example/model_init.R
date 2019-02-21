model_init <- function(model_name){
    ###########################
    ## Defensive Programming ##
    ###########################
    ## Do not edit this part by hand
    assertive::assert_is_a_non_empty_string(model_name)
    ## Here you may add your assertions. Useful expressions include:
    ## * base::missing() - test whether a value was specified as a function arg
    ## * base::stopifnot() - for conditional statements to ensure code integrity
    ## * if(conditional statements) stop(<failure reason>)
    ## * {assertive} - informative check functions to ensure code integrity
    
    
    ###########
    ## Setup ##
    ###########
    ## Initialize the caching engine
    model_archive <<- file.path(k_path_cache, model_name)
    unlink(model_archive, recursive = TRUE, force = TRUE)
    archivist::createLocalRepo(model_archive, force = TRUE, default = TRUE)
    ## Get model's metadata from yaml file and make it available globally
    ## Note: model's metadata may contain parameters to pass into the model
    model_yaml <- rmonic::load_model_metadata(model_name, k_path_models)
    
    
    ######################
    ## Global Variables ##
    ######################
    ## Add model metadata parameters to the global environment
    list2env(model_yaml[["model_metadata"]], envir = .GlobalEnv)
    ## Other important variables
    ### Generate slug tags from the model metadata
    slug_model <<- compose_tags(model_yaml[["model_metadata"]])
    slug_model_fit <<- compose_tags(slug_model, source = "model_fit")
    slug_model_predict <<- compose_tags(slug_model, source = "model_predict")
    ### The sampled data split number
    split_num <<- 0
    
    
    ##################
    ## Calculations ##
    ##################
    ## Here you may add your code
    
    
    ############
    ## Return ##
    ############
    ## Do not edit this part by hand
    return(invisible())
}
