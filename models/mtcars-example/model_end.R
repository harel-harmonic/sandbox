model_end <- function(){
    ###########################
    ## Defensive Programming ##
    ###########################
    ## Here you may add your assertions
    assertive::assert_all_are_existing(c("model_name", "list_of_bind_tables"),
                                       envir = .GlobalEnv)


    #############################################
    ## Join the Predictions and their Metadata ##
    #############################################
    PREDICTIONS <-
        rmonic::join_predictions_tables(
            list_of_bind_tables$PREDICTIONS_DATA,
            list_of_bind_tables$PREDICTIONS_METADATA
        )
    rmonic::assert_objects_have_the_same_number_of_observations(PREDICTIONS, list_of_bind_tables$PREDICTIONS_DATA)


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
        PREDICTIONS %>%
        dplyr::group_by(OBSERVATION_UID) %>%
        dplyr::summarise(RESPONSE_VALUE = median(RESPONSE_VALUE, na.rm = TRUE))
    ## Make a submission
    submit_predictions(submission_data, model_name)


    ############
    ## Return ##
    ############
    return(PREDICTIONS)
}
