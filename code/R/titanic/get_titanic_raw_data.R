#' get_titanic_raw_data
#'
#'
get_titanic_raw_data <- function(){
    #########
    # Setup #
    #########
    input_folder <- file.path(k_path_data_raw, "titanic")
    file_input_1 <- file.path(input_folder, "titanic_train.csv")
    file_input_2 <- file.path(input_folder, "titanic_test.csv")
    #'
    ####################
    # Input validation #
    ####################
    assert_all_are_existing_files(c(file_input_1, file_input_2))
    #'
    ############################
    # Bind train and test sets #
    ############################
    titanic_raw <- bind_rows(train = read_csv(file_input_1),
                             test = read_csv(file_input_2),
                             .id = "Set")
    #'
    ##########
    # Return #
    ##########
    return(titanic_raw)
}