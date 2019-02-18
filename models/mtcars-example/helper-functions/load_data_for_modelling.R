load_data_for_modelling <- function(){
    ##################
    ## Get the Data ##
    ##################
    ## Import the data
    dataset <- mtcars


    ########################
    ## Data Preprocessing ##
    ########################
    ## Standardise column names
    dataset <- dataset %>% rmonic::standardize_col_names()
    ## Set the unique key column
    unique_key_column <- "ROWID"
    ## Add a unique identifier such that each observation (row) is associated with
    ## a unique ID. Named it "ROWID".
    dataset <- dataset %>% tibble::rownames_to_column(var = unique_key_column)
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
