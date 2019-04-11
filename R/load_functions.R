#' @title
#' Load All Functions in a Given Folder
#'
#' @description
#' Loads all the functions in a given folder to a given environment.
#'
#' @param path (`character`) the folder containing the R functions.
#' @param envir (`environment`) the environment in which to load the functions to.
#'
#' @return NULL
#'
#' @export
#'
#' @family rmonicverse
#'
load_functions <- function(path = file.path(getwd(), "R"), envir = .GlobalEnv) {
    ###########################
    ## Defensive Programming ##
    ###########################
    assertive::assert_is_a_non_missing_nor_empty_string(path)
    assertive::assert_is_environment(envir)
    
    ##############################
    ## Load Project's Functions ##
    ##############################
    invisible({
        # Get the functions paths
        functions_paths <- list.files(path,
                                      pattern = "*.R$",
                                      all.files = TRUE,
                                      full.names = TRUE,
                                      ignore.case = TRUE,
                                      recursive = TRUE
        )
        # Load the functions
        source_function <- function(x, ...) try(source(x, ...), silent = TRUE)
        if (length(functions_paths) == 0) {
            invisible()
        } # warning("No functions were found in ", path)
        else {
            sapply(functions_paths, source_function, local = envir)
        }
    })
    
    ############
    ## Return ##
    ############
    return(invisible())
}
