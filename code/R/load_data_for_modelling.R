#' @title Load Data for Modelling
#'
#' @description load_data_for_modelling provides the data for the modelling
#'   stage.
#'
#' @details \code{rmonic} focal point is on the modelling process. Yet, to
#'   proceed with the modelling phase, a prior phase of preparing data for
#'   modelling is needed.
#'
#'   The data and the programming logic varies from one project to another.
#'   Therefore, it is not possible to generalize it to work
#'   out-of-the-rmonic-box. Instead, it is up to the product-owner/team-leader
#'   to define its content.
#'
#' @note: Using this function is one way of enabling the project data source for
#' modelling. In case you choose to use the function, here are some good
#' practices to increase reproducibility:
#'
#' \enumerate{
#'   \item Return an object created by \code{rsample}.
#'   \item Store the function in the project's shared function folder
#'   (i.e. \code{k_path_functions}).
#' }
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @return An object created by \code{rsample}.
#'
load_data_for_modelling <- function(){
    ###########################
    ## Defensive Programming ##
    ###########################
    assertive::assert_all_are_existing(
        c("dataset_name", "dataset_key_column"),
        envir = .GlobalEnv)


    ##################
    ## Get the Data ##
    ##################
    ## Import the data
    dataset <- get(dataset_name)
    ########################
    ## Data Preprocessing ##
    ########################
    ## Standardise column names
    dataset <- dataset %>% rmonic::standardize_col_names()
    ## Add a unique identifier such that each observation (row) is associated with
    ## a unique ID. Named it in accordance with dataset_key_column.
    dataset <- dataset %>% tibble::rownames_to_column(var = dataset_key_column)
    rownames(dataset) <- NULL


    ####################
    ## Split the Data ##
    ####################
    ## Option 1: Split the data to 70%/30% Training/Test sets
    # set.seed(902)
    # rset_obj <- rsample::initial_split(dataset, prop = 0.7)
    ## Option 2: K-fold cross validation
    set.seed(902)
    rset_obj <- rsample::vfold_cv(dataset, v = 5)
    ## Option 3: Bootstrap Sampling
    # set.seed(902)
    # rset_obj <- rsample::bootstraps(dataset, times = 20)


    ############
    ## Return ##
    ############
    return(rset_obj)
}
