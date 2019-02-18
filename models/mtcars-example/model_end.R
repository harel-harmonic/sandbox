model_end <- function(){
    ###########################
    ## Defensive Programming ##
    ###########################
    ## Here you may add your assertions
    assertive::assert_all_are_existing(c("model_name", "slug_model"), envir = .GlobalEnv)


    #############################################
    ## Join the Predictions and their Metadata ##
    #############################################
    query <- rmonic::compose_tags(slug_model)
    predictions_full_table <<- rmonic::retrieve_table(query) %>% rmonic::standardize_col_names()
    predictions_long_table <<- predictions_full_table %>% dplyr::select(RESPONSE_TYPE,SPLIT,KEY,VALUE)
    predictions_wide_table <<- predictions_long_table %>% tidyr::spread(key = RESPONSE_TYPE, value = VALUE)


    ########################################################################
    ## Upload the Predictions to a Centralised Place for Further Analysis ##
    ########################################################################
    ##
    ## NOTE [@product-owner]:
    ## This function is defined by the product owner. By default, it assumes the
    ## first input argument is a predictions table where the:
    ## * 1st column contains the observations unique identifiers (UIDs). These
    ## values correspond to the UIDs of the original dataset identified prior to
    ## the modelling process. The UIDs link between the predictions table and
    ## the ground truth.
    ## * 2nd column contains non-negative prediction values.
    ##
    ## Collapse the table by observation id
    submission_data <-
        predictions_full_table %>%
        dplyr::filter(RESPONSE_TYPE %in% "fit") %>%
        dplyr::group_by(KEY) %>%
        dplyr::summarise(VALUE = mean(VALUE))
    ## Make a submission
    submit_predictions(artifact = submission_data, tags = slug_model)


    ############
    ## Return ##
    ############
    ## Do not edit this part by hand
    return(invisible())
}
