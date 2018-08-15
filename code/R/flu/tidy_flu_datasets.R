#' tidy_flu_datasets
#' 
tidy_flu_datasets <-function(flu_datasets){
    message("---")
    message("Tidying up the flu datasets")
    
    # Input validation
    assert_is_list(flu_datasets)
    
    # Data frame allocation
    flu_long_datasets <- data.frame()
    
    # Create a long tidy data frame
    for(k in 1:length(flu_datasets)){
        message("-> ", "Tidying up flu data of ", names(flu_datasets)[k])
        
        # Unlist one of the dataframes
        flu_dataset <- flu_datasets[[k]]
        flu_country <- names(flu_datasets)[k]
        
        # For the selected country, create a long data frame with a location column.
        # Note: the Index column represent the search activity in a location at a 
        #       specific time
        flu_long_dataset <- 
            flu_dataset %>% 
            tidyr::gather(key = "Location", value = "Index", -Date) %>%
            add_column(Country = flu_country) %>%
            select(Date, Country, Location, Index)
        
        # Combine the datasets
        flu_long_datasets <- bind_rows(flu_long_datasets, flu_long_dataset)
    }
    
    # Arrange the data
    flu_long_datasets <- 
        flu_long_datasets %>%
        dplyr::arrange(Date, Country, Location, Index)
    
    # Return
    return(flu_long_datasets)
}