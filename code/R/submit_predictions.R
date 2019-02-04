## submit_predictions
##
#' @title Upload the Predictions to a Centralised Place for Further Analysis
#'
#' @description Upload predictions and context about their creation to a
#'   centralised place. This allows further analysis including model evaluation
#'   and model comparison.
#'
#' @param data (`data.frame`) A predictions table with two columns:
#'
#' * 1st column contains observations with unique identifiers (UIDs). These
#' values correspond to the UIDs of the original dataset identified prior to the
#' modelling process. The UIDs link between the predictions table and the ground
#' truth.
#'
#' * 2nd column contains the predictions values.
#'
#' @param model_name (`character`) the model name.
#'
#' @param path (`character`) absolute or relative path of the model's parent folder.
#'
#' @details This function is customised and defined by the product owner. Its
#'   programming logic is as follow:
#'
#' 1. The function checks the validity of the input arguments. If an assumption
#' is violated, such as UIDs are not unique, the function prompts an informative
#' error.
#'
#' 2. The function processes the data for submission.
#'
#' 3. The function uploads / stored the data and its context. The location and
#' technique are are defined by the product owner.
#'
#' @section Note to Product Owner: To facilitate understanding between
#'   individual contributors, consider providing a \code{sample_submission.csv}
#'   file, say under \code{~/data/submissions}. This is as an example of what a
#'   submission file should look like. This file includes the structure of the
#'   anticipated predictions table. In the first column it has the (real)
#'   observations UIDs. The other column(s) carry the name of the target
#'   variables. You may pad the empty cells with zeros, NAs or some benchmark
#'   model values.
#'
#' @return NULL
#'
submit_predictions <- function(data, model_name, path = k_path_models){
    ###########################
    ## Defensive Programming ##
    ###########################
    ## data
    assertive::assert_is_data.frame(data)
    stopifnot(ncol(data) == 2)
    ### 1st column
    if(data[, 1] %>% is.na() %>% any()) stop("The 1st column contains NA values")
    assertive::assert_has_no_duplicates(data[, 1])
    ### 2nd column
    if(data[, 2] %>% is.na() %>% any()) stop("The 2nd column contains NA values")
    assertive::assert_all_are_non_negative(data[[2]])
    ## model_name
    assertive::assert_is_a_non_missing_nor_empty_string(model_name)
    ## models folder path
    assertive::assert_all_are_dirs(path)


    ####################################
    ## Preprocess the Submission Data ##
    ####################################
    ## Predictions table
    colnames(data) <- rmonic::standardize_strings(c("KEY", "VALUE"))
    ## Predictions context
    metadata <- rmonic::load_model_metadata(model_name, path)


    #######################
    ## Make a Submission ##
    #######################
    ## NOTE [@product-owner]:
    ## This part is defined by the product owner. Two possibilities are:
    ## 1. Save the submission data to a local repo (consider using
    ## k_path_submissions); And/Or
    ## 2. Save the submission data to a shared repo.
    # artifact <- data
    # tag <- rmonic::compose_model_name(model_uid = metadata[["model_uid"]])
    # create_date <- Sys.time() %>% as.POSIXct() %>% as.character()


    ############
    ## Return ##
    ############
    return(invisible())
}
