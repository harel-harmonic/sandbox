# checkpoint --------------------------------------------------------------
#
#' @title Configures R Session to Use Packages as they Existed on CRAN at time
#'   of Snapshot
#'
#' @description This function extends the abilities of
#'   \code{\link[checkpoint]{checkpoint}}.
#'
#' @details This version of \code{checkpoint} does the following:
#'
#' * **Explicitly** telling the package manager which packages to install. This
#' is on top of the implicit engine built in
#' \code{\link[checkpoint]{checkpoint}}.
#'
#' * Gives a solution to the problem of **installing packages which are not on
#' CRAN**. This is done by coping pre-installed packages directories to the
#' checkpoint folder.
#'
#' * Install all packages **dependencies** and **imports** as specified in each
#' package DESCRIPTION file.
#'
#' * **Simplefies** the package manager configurations by pointing it to install
#' the packages in working directory.
#'
#' @param snapshot_date (`character`) Date of snapshot to use in YYYY-MM-DD
#'   format, e.g. "2014-09-17".
#' @param pkgs (`character`) A vector of the names of packages whose snapshot
#'   versions should be downloaded from the repositories.
#'
#' @note The \pkg{checkpoint} package is not required to be installed.
#'
#' @export
#'
#' @import checkpoint
#'
#' @return NULL
#'
checkpoint <- function(snapshot_date, pkgs){
    ###########################
    ## Defensive Programming ##
    ###########################
    stopifnot(class(pkgs) == "character" | length(pkgs) == 0)


    ######################
    ## Helper Functions ##
    ######################
    .library <- function(x) paste0("library(",x,")")
    .require <- function(x) eval(parse(text = paste0("require(",x,", quietly = TRUE)")))
    is.error <- function(x) return(class(try(x, silent= TRUE)) %in% "try-error")
    extract_elements_from_parentheses <- function(x) as.character(sapply(x, function(x) regmatches(x, gregexpr("(?<=\\().*?(?=\\))", x, perl=T))[[1]]))


    ###########
    ## Setup ##
    ###########
    k_path_project <- tryCatch(rprojroot::find_rstudio_root_file(), error = function(e) getwd())
    snapshot_date <- as.character(snapshot_date)
    pkgs <- extract_elements_from_parentheses(pkgs)


    ###############################
    ## Phase 1: Install Packages ##
    ###############################
    ## Create the checkpoint dir
    dir.create(file.path(k_path_project,".checkpoint"), showWarnings = FALSE, recursive = TRUE)
    ## Install and load {checkpoint}
    suppressWarnings(
        suppressPackageStartupMessages(
            if(!.require("checkpoint")){
                utils::install.packages("checkpoint")
            } else {
                checkpoint::unCheckpoint()
            }
        )
    )
    ## Help {checkpoint} to identify which packages are needed in this project
    packages <- unique(c(pkgs, "yaml", "fs"))
    libraries <- sapply(packages, .library)
    requirements_path <- file.path(k_path_project, "_requirements.R")
    unlink(requirements_path)
    writeLines(paste0(libraries, collapse = "\n"), requirements_path)
    ## Store search paths for packages
    uncheckpoint.lib.loc <- .libPaths()
    ## Activate {checkpoint}
    report <- try(
        checkpoint::checkpoint(snapshot_date,
                               project = k_path_project,
                               checkpointLocation = k_path_project,
                               verbose = FALSE), #checkpoint
        silent = TRUE)#try
    checkpoint.lib.loc <- .libPaths()
    ## Try to copy packages which weren't installed by {checkpoint}
    pkgs_found <- list.dirs(checkpoint.lib.loc[1], full.names = FALSE, recursive = FALSE)
    pkgs_not_found <- setdiff(pkgs, pkgs_found)
    for(k in seq_along(pkgs_not_found)){
        try({
            source <- system.file(package = pkgs_not_found[k], lib.loc = uncheckpoint.lib.loc)
            target <- file.path(checkpoint.lib.loc[1], basename(source))
            if(!dir.exists(target)){
                fs::dir_copy(source, target)
                message("--> Copied {", pkgs_not_found[k], "} from this machine into '.checkpoint' folder")
            } # copy package
        }, silent = TRUE) # try
    }# pkgs_not_found for-loop
    ## Clean up
    unlink(requirements_path)


    ############################################
    ## Phase 2: Install Packages Dependencies ##
    ############################################
    dependencies <- c()
    ## Search for dependencies
    for(k in seq_along(packages)){
        try({
            ## Get the package DESCRIPTION file
            source <- system.file("DESCRIPTION" ,package = packages[k], lib.loc = checkpoint.lib.loc[1])
            description <- yaml::yaml.load_file(source)
            ## Extract the packages to install
            depends <- sub(" .*$", "", description$Depends)
            imports <- sub(" .*$", "", description$Imports)
            package_dependencies <- c(depends, imports)
            ## Store dependencies
            dependencies <- c(dependencies, package_dependencies)
        }, silent = TRUE)
    }
    ## Add dependencies to _requirements.R
    packages <- unique(packages, dependencies)
    libraries <- sapply(packages, .library)
    requirements_path <- file.path(k_path_project, "_requirements.R")
    writeLines(paste0(libraries, collapse = "\n"), requirements_path)
    ## Reset {checkpoint}
    checkpoint::unCheckpoint()
    checkpoint::checkpoint(snapshot_date,
                           project = k_path_project,
                           checkpointLocation = k_path_project,
                           verbose = FALSE)
    ## Clean up
    unlink(requirements_path)


    ############
    ## Return ##
    ############
    cat("\033[42mCheckpoint Package Manager is Activated\033[49m", sep = "\n")
    return(invisible())
}
