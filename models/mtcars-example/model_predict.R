model_predict <- function(test_set)
{
    ###########################
    ## Defensive Programming ##
    ###########################
    ## Do not edit this part by hand
    assertive::assert_has_rows(test_set)
    assertive::assert_all_are_existing(c("model_uid", "split_num", "unique_key_column"), envir = .GlobalEnv)
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
    mdl_tags <- rmonic::compose_tags(previous_stage_tags, target_variable = "mpg")

    ## Retrieve the model
    mdl_obj <- rmonic::load_artifact(mdl_tags)


    ##########################
    ## Predict the Test Set ##
    ##########################
    response_vars <- predict(mdl_obj, test_set, interval = "predict")
    rmonic::assert_objects_have_the_same_number_of_observations(response_vars, test_set)


    ###################################
    ## Store Predictions in Database ##
    ###################################
    ## Structure the prediction data in a key-value table
    uids <- test_set[,unique_key_column]
    y_fit <- rmonic::kv_table(key = uids, value = response_vars[,"fit"])
    y_upr <- rmonic::kv_table(key = uids, value = response_vars[,"upr"])
    y_lwr <- rmonic::kv_table(key = uids, value = response_vars[,"lwr"])
    ## Save prediction tables in database
    rmonic::save_artifact(y_fit, compose_tags(current_stage_tags, response_type = "fit"))
    rmonic::save_artifact(y_upr, compose_tags(current_stage_tags, response_type = "upr"))
    rmonic::save_artifact(y_lwr, compose_tags(current_stage_tags, response_type = "lwr"))


    ############
    ## Return ##
    ############
    ## Do not edit this part by hand
    return(invisible())
}
