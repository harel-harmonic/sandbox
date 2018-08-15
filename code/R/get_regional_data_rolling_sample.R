#' get_regional_data_rolling_sample
#'
#'
get_regional_data_rolling_sample <- function(data ,location){
    # Input validation
    stopifnot(!missing(data), !missing(location))
    assert_is_data.frame(data)
    assert_all_are_non_missing_nor_empty_character(location)
    assert_is_subset("LOCATION", colnames(data))
    
    # Subset the dataset
    local_data <- data %>% dplyr::filter(LOCATION %in% location)
    assert_is_non_empty(local_data)
    
    # Split the data with moving window
    # * Use initial sample of one year
    # * In each epoch, assess a period of 4 weeks
    # * Skip inter period predictions 
    roll_rs <- 
        local_data %>%
        rolling_origin(initial = 52, assess = 4, skip = 4)
    
    # Return
    return(roll_rs)
}