## submit_predictions
##
#' @title Upload the Predictions to a Centralised Place for Further Analysis
#'
#' @description Upload predictions and context about their creation to a
#'   centralised place. This allows further analysis including model evaluation
#'   and model comparison.
#'
#' @param artifact (`data.frame`) A predictions table with two columns:
#'
#' * 1st column, named KEY contains observations with unique identifiers. These
#' values correspond to the keys of the original dataset prior to the modelling
#' process. The keys link between the predictions table and the ground truth.
#'
#' * 2nd column, named VALUE, contains the predictions values.
#'
#' @param tags (`character`) A character vector with Tags. Each tag is a key-value pair in the following format "key:value". These Tags will be added to the repository along with the artifact. Tags can be easily assembled by \code{\link[rmonic]{compose_tags}}).
#'
#' @details This function is customised and defined by the product owner. Its
#'   programming logic is as follow:
#'
#' 1. The function checks the validity of the input arguments. If an assumption
#' is violated, such as KEY values are not unique, the function prompts an
#' informative error.
#'
#' 2. The function processes the data for submission.
#'
#' 3. The function uploads / stored the data and its context. The location and
#' technique are defined by the product owner.
#'
#' @section Note to Product Owner: To facilitate understanding between
#'   individual contributors, consider providing a \code{sample_submission.csv}
#'   file, say under \code{~/data/submissions}. This is as an example of what a
#'   submission file should look like. This file includes the structure of the
#'   anticipated predictions table. In the first column, KEY, it has the (real)
#'   observations unique identifiers. The other column(s), carry the name of the
#'   target variables. You may pad the empty cells with zeros, NAs or some
#'   benchmark model values.
#'
#' @return NULL
#'
#' @export
#'
submit_predictions <- function(artifact, tags){
    msgs <- "Uploading the predictions for further analysis..."

    ###########################
    ## Defensive Programming ##
    ###########################
    ## Global variables existence
    assertive::assert_all_are_existing(c("k_path_models", "model_name", "k_path_submissions"))
    ## Check if tags are valid
    invisible(rmonic::decompose_tags(tags))
    ## Check if artifact is a valid dataset
    assertive::assert_is_data.frame(artifact)
    ## Check table content
    ### Columns names
    expected_cols <- c("KEY", "VALUE") %>% sort()
    actual_cols <- colnames(artifact) %>% sort()
    assertive::assert_is_subset(expected_cols, actual_cols)
    ### No NAs
    assertive::assert_is_identical_to_false(artifact %>% dplyr::select(KEY, VALUE) %>% is.na() %>% any())


    #####################
    ## Helper Function ##
    #####################
    compose_nested_tags <- function(x) {
        tags <- c()
        for (l in seq_along(x))
            try(
                tags <- c(tags, compose_tags(unlist(x[[l]]))),
                silent = TRUE
            )
        unique(tags)
    }


    ####################################
    ## Preprocess the Submission Data ##
    ####################################
    ## Transform artifact to an Entity–Attribute–Value Table
    artifact <- rmonic::as.eav_table(artifact)
    ## Compose tags
    submission_timestamp <- lubridate::now("UTC") %>% as.character()
    source <- file.path(k_path_models, model_name, "config.yml")
    model_metadata <- yaml::yaml.load_file(source)
    tags <- rmonic::compose_tags(
        "submission_timestamp" = submission_timestamp,
        compose_nested_tags(model_metadata)
    )


    #######################
    ## Make a Submission ##
    #######################
    ## Retain the submission in an archive
    if(rmonic::is_artifact_in_archive(artifact, k_path_submissions)){
        msg <- "\033[46mSubmission Skipped\033[49m"
        msg <- c(msg, "An identical submission was found in the archive.")

    } else {
        msg <- tryCatch({
            rmonic::save_artifact(artifact, tags, k_path_submissions)
            msg <- "\033[42mSubmission Successful\033[49m."
        }, error = function (e){
            msg <- "\033[41mSubmission Failed\033[49m."
            msg <- c(msg, e$message)
        }) # end tryCatch
    }# end if-else
    msgs <- c(msgs, msg)
    ## Store the submission as flat files on disk
    md5hash <- digest::digest(artifact, algo = "md5")
    target_data <- file.path(k_path_submissions, paste0(md5hash, ".csv"))
    target_tags <- file.path(k_path_submissions, paste0(md5hash, ".yml"))
    utils::write.csv(x = artifact, file = target_data, row.names = FALSE)
    yaml::write_yaml(x = tags, file = target_tags)


    ############
    ## Return ##
    ############
    cat(msgs,  sep = "\n")
    return(invisible())
}
