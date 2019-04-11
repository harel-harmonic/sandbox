context("test-load_functions")
#' Case 1: folder with invalid functions
#' Case 2: folder with valid functions
#' Case 3: folder without files (empty folder)
#'
##########
# Case 1 #
##########
test_that("load_functions works given a folder with invalid functions", {
    # Create a temporary folder
    folder_path <- file.path(tempdir(check = TRUE), "R")
    dir.create(folder_path, showWarnings = FALSE, recursive = TRUE)
    
    # Create invalid functions
    ## Empty file
    empty_file_path <- file.path(folder_path, "empty_file.R")
    write.table("", empty_file_path, col.names = FALSE, row.names = FALSE, quote = FALSE)
    ## Script
    script_file_path <- file.path(folder_path, "two_plus_two.R")
    script_content <- "a <- 2 + 2"
    write.table(script_content, script_file_path, col.names = FALSE, row.names = FALSE, quote = FALSE)
    ## Broken function
    invalid_function_path <- file.path(folder_path, "invalid_function.R")
    function_content <- "invalid_function <- function(){return(NULL)#}"
    write.table(function_content, invalid_function_path, col.names = FALSE, row.names = FALSE, quote = FALSE)
    
    # Execute function on folder
    expect_null(load_functions(path = folder_path, envir = environment()))
    
    # Clean up: Delete the temporary folder
    unlink(folder_path, recursive = TRUE)
})
#'
##########
# Case 2 #
##########
test_that("load_functions works given a folder with valid functions", {
    # Create a temporary folder
    folder_path <- proj_path("temp", "code", "R")
    unlink(folder_path, recursive = TRUE)
    dir.create(folder_path, showWarnings = FALSE, recursive = TRUE)
    
    # Unload foo, bar and .baz
    suppressWarnings(rm(foo, bar, .baz))
    
    # Create dummy functions named "foo.R" and "bar.r"
    # (upper and lower R file extensions)
    foo_path <- file.path(folder_path, "foo.R")
    bar_path <- file.path(folder_path, "bar.r")
    baz_path <- file.path(folder_path, ".baz.r")
    foo_content <- "foo <- function(){return(NULL)}"
    bar_content <- "bar <- function(){return(NULL)}"
    baz_content <- ".baz <- function(){return(NULL)}"
    write.table(foo_content, foo_path, col.names = FALSE, row.names = FALSE, quote = FALSE)
    write.table(bar_content, bar_path, col.names = FALSE, row.names = FALSE, quote = FALSE)
    write.table(baz_content, baz_path, col.names = FALSE, row.names = FALSE, quote = FALSE)
    
    # Execute function on the folder where "foo" is saved
    ## Make sure foo is not loaded
    expect_true(assertive::are_disjoint_sets(c("foo", "bar", ".baz"), ls(envir = environment())))
    ## Load all functions
    expect_silent(load_functions(path = folder_path, envir = environment()))
    ## Make sure foo and bar are loaded
    expect_true(assertive::is_subset(c("foo", "bar"), ls(envir = environment())))
    ## Make sure .baz is loaded
    expect_true(exists(".baz"))
    
    # Clean up
    ## Unload foo, bar and .baz
    suppressWarnings(rm(foo, bar, .baz))
    ## Delete the temporary folder
    unlink(folder_path, recursive = TRUE)
})
#'
##########
# Case 3 #
##########
test_that("load_functions works given a folder without files (empty folder)", {
    # Create a temporary folder
    folder_path <- file.path(tempdir(check = TRUE), "R")
    dir.create(folder_path, showWarnings = FALSE, recursive = TRUE)
    
    # Execute function on an empty folder
    expect_null(load_functions(path = folder_path, envir = environment()))
    
    # Clean up: Delete the temporary folder
    unlink(folder_path, recursive = TRUE)
})
