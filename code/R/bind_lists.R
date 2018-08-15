#' bind_lists 
#' 
#' 
bind_lists <- function(data){
    # Input validation
    assert_is_list(data)
    
    # Allocate data frame
    data_df <- data.frame()
    
    for(k in seq_along(data)){
        data_df <- 
            data_df %>%
            bind_rows(data[[k]] %>% add_column("list" = k, .before = 1))
    }
    
    # Return
    return(data_df)
}