model_predict <- function(test_set)
{
    ###########################
    ## Defensive Programming ##
    ###########################
    ## Do not edit this part by hand
    assertive::assert_has_rows(test_set)
    assertive::assert_all_are_existing(
        c("model_uid", "split_num", "dataset_key_column", "model_archive"),
        envir = .GlobalEnv)
    ## Here you may add your assertions


    ###########
    ## Setup ##
    ###########
    # Compose stages tag slugs
    previous_stage_tags <- rmonic::compose_tags(slug_model_fit, split = split_num)
    current_stage_tags <- rmonic::compose_tags(slug_model_predict, split = split_num)


    ###################################
    ## Retrieve the Prediction Model ##
    ###################################
    ## Compose database query for the desiered model
    model_tags <- rmonic::compose_tags(previous_stage_tags, target_variable = "mpg")

    ## Retrieve the model
    model_object <- rmonic::load_artifact(model_tags, model_archive)


    ##########################
    ## Predict the Test Set ##
    ##########################
    response_vars <- predict(model_object, test_set, interval = "predict")
    rmonic::assert_objects_have_the_same_number_of_observations(response_vars, test_set)


    ###################################
    ## Store Predictions in Database ##
    ###################################
    ## Structure the prediction data in a key-value table
    uids <- test_set[,dataset_key_column]
    y_fit <- rmonic::kv_table(key = uids, value = response_vars[,"fit"])
    y_upr <- rmonic::kv_table(key = uids, value = response_vars[,"upr"])
    y_lwr <- rmonic::kv_table(key = uids, value = response_vars[,"lwr"])
    ## Compose artifacts tags
    tags_fit <- compose_tags(current_stage_tags, response_type = "fit")
    tags_upr <- compose_tags(current_stage_tags, response_type = "upr")
    tags_lwr <- compose_tags(current_stage_tags, response_type = "lwr")
    ## Save prediction tables in database
    rmonic::save_artifact(y_fit, tags_fit, model_archive)
    rmonic::save_artifact(y_upr, tags_upr, model_archive)
    rmonic::save_artifact(y_lwr, tags_lwr, model_archive)


    ############
    ## Return ##
    ############
    ## Do not edit this part by hand
    return(invisible())
}
