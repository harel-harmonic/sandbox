################################################################################
#                           Load Project's Functions                           #
################################################################################
#'
load_project_functions <- function() {
    ####################
    # Input validation #
    ####################
    #' Check that the required parameters exist
    stopifnot(
        exists("k_path_functions"),
        exists("k_path_modules")
    )
    #'
    ############################
    # Load project's functions #
    ############################
    invisible(
        sapply(
            list.files(k_path_functions,
                pattern = "*.R$", full.names = TRUE, recursive = TRUE,
                ignore.case = TRUE
            ),
            source,
            local = globalenv()
        )
    )
    #'
    ##########################
    # Load project's modules #
    ##########################
    invisible(
        sapply(
            list.files(k_path_modules,
                pattern = "*.R$", full.names = TRUE, recursive = TRUE,
                ignore.case = TRUE
            ),
            source,
            local = globalenv()
        )
    )
    #'
    ##########
    # Return #
    ##########
    return(invisible())
}
