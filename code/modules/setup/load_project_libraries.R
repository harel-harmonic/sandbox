################################################################################
#                           Load Project's Libraries                           #
################################################################################
#' What does the script do:
#' The scripts holds the names of the required libraries for this project.
#' It then make sure the libraries are installed and loaded to the project env.
#' Note, that the script handels packages both from CRAN and from GitLab in an
#' automatic fashion.
#'
#' How to use the script:
#' 1. Specify the required packages to install (and load) from CRAN
#' 2. Specify the required packages to install (and load) from GitHub
#' 3. Source it at the beginning of relevant scripts in the following manner:
#' path_scripts = file.path(getwd(), "code", "core", "scripts")
#' source(file.path(path_scripts, "load-libraries.R"))
#'
#' Note:
#' When Specifying packages, provide description (as comments) of their domain.
#' For example, Parallel computing, Interactive visualization, Tools to manage
#' spatial Object, etc.
#' This implies that packages from the same domain are clustered together when
#' declared by the user.
#'
load_project_libraries <- function() {
    #########
    # Setup #
    #########
    Sys.setlocale("LC_TIME", "English")
    #'
    #############################
    # Define project's packages #
    #############################
    #' CRAN Packages
    libraries_on_CRAN <- c(
        # Essential packages
        "devtools", "assertive",
        # Data Manipulation
        "tidyverse", "lubridate", "forcats", "magrittr",
        # Graphic Displays
        "ggplot2", "corrplot",
        # HTML Widgets
        "plotly", "ggvis", "DT",
        # Reproducible Research
        "knitr", "rmarkdown", "kableExtra",
        # Meta-package for modeling and statistical analysis that share the
        # underlying design philosophy, grammar, and data structures of the
        # tidyverse.
        "tidymodels",
        # 1. A set of tools for datasets and plots archiving
        # 2. Descriptive mAchine Learning EXplanation
        "archivist", "DALEX",
        # Machine Learning
        "mlr", "xgboost", "caret", "gbm", "prophet", "randomForest",
        # Parallel Computation Tools
        "foreach", "parallel", "doParallel",
        # Misc
        # (1) Conflict packages resolution strategy; filter <- dplyr::filter
        "conflicted",
        # (2) Non-invasive pretty printing of R code
        "styler",
        # (3) Perform a computation in a separate R process
        "callr",
        # (4) A cross-platform interface to file system operations
        "fs"
    )
    #' GitHub Packages
    libraries_on_GitHub <- c(
        # Partitions a data frame across multiple cores.
        "hadley/multidplyr",
        # Addin to RStudio, which finds all TODO, FIXME, CHANGED
        "dokato/todor",
        # Interactive Charts from R using rCharts
        "ramnathv/rCharts",
        # Generates a website with HTML summaries for predictive models.
        "MI2DataLab/modelDown"
    )
    #'
    ###########################
    # Install & load packages #
    ###########################
    #' Create requirements.R; an R script with the project libraries. This useful
    #' when using a package manager as it searches the project's files to determine
    #' which libraries are required.
    suppressWarnings(
        if (!require("pacman", quietly = TRUE)) {
            install.packages("pacman")
        }
    )
    pacman::p_load(char = libraries_on_CRAN, install = TRUE, update = FALSE)
    pacman::p_load_gh(char = libraries_on_GitHub, install = TRUE, update = FALSE)
    #'
    ##########
    # Return #
    ##########
    return(invisible())
}
