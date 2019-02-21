submit_predictions <- function(artifact, tags){
    msgs <- "Uploading the predictions for further analysis"
    
    ###########################
    ## Defensive Programming ##
    ###########################
    ## Global variables existence
    assertive::assert_all_are_existing("k_path_submissions",
                                       envir = .GlobalEnv)
    ## Check if tags are valid
    invisible(rmonic::decompose_tags(tags))
    ## Check if artifact is a valid dataset
    assertive::assert_is_data.frame(artifact)
    stopifnot(ncol(data) == 2)
    ### 1st column
    if(artifact %>% select(+1) %>% is.na() %>% any()) stop("The 1st column contains NA values")
    assertive::assert_has_no_duplicates(artifact %>% select(+1))
    ### 2nd column and forward
    if(artifact %>% select(-1) %>% is.na() %>% any()) stop("The 2nd column contains NA values")
    assertive::assert_all_are_non_negative(artifact %>% select(-1) %>% as.matrix())
    
    
    ####################################
    ## Preprocess the Submission Data ##
    ####################################
    NULL
    
    
    #######################
    ## Make a Submission ##
    #######################
    if(rmonic::is_artifact_in_archive(artifact, k_path_submissions)){
        msg <- "\033[46mSubmission Skipped\033[49m. An identical submission was found in the archive."
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
    
    
    ############
    ## Return ##
    ############
    cat(msgs,  sep = "\n")
    return(invisible())
}
