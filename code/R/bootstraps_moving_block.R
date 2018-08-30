#' bootstraps_moving_block
#'
#' @param block_complete "both", "left" or "right"; 
#' the blocks in the begining and end are problemtic, as they contain less 
#' than \code{block_size} observations. Specifying this parameter ensures the desired ends
#' is sameple among \code{block_size} observations. 
#' 
#' @note \code{block_complete}="rigth" might be desirable in some cases as it 
#' ensures the closer the sample gets to the end of the series, it is more  
#' likely to get the real observed value
#' 
bootstraps_moving_block <- function(data, 
                                    times = 25, 
                                    block_size){
    ####################
    # Input validation #
    ####################
    stopifnot(!missing(data), !missing(block_size))
    assert_is_data.frame(data)
    assert_all_are_positive(c(times, block_size))
    #'
    #########
    # Setup #
    #########
    n <- nrow(data)
    block_quantity <- n / block_size
    # TODO handle sequence where the number of instances is not a multiplication of the block size
    stopifnot(block_quantity == round(block_quantity))
    #'
    #############################
    # Create bootstrap skeleton #
    #############################
    # Add strata column to the data
    data <- 
        data %>%
        add_column(strata = rep(1:block_quantity, each = block_size), .before = 1)
    # Create the skeleton for the time series bootstrap
    rset <- rsample::bootstraps(data, times, "strata")
    #'
    ##########################
    # Moving block bootstrap #
    ##########################
    # Find the indices of each block
    block_indices <- sapply(1:(n-block_size+1),
                            function(x) seq.int(from = x, to = x + (block_size-1)))
    block_indices <- t(block_indices)
    # Complement the last incomplete blocks
    block_indices <- rbind(block_indices,
                           block_indices[rep(nrow(block_indices), block_size-1),])
    # Convert data frame to list
    block_indices <- split(block_indices, block_indices %>% nrow() %>% seq())
    #'
    ########################
    # Bootstrap the sample #
    ########################
    bootstrap_sampling <- function(x,...){
        if(length(x)==1){ # if the sample size is one, then return the sample value
            x
        } else { # else sample with replacement
            base::sample(x, 1, replace = TRUE)
        }
    }# bootstrap_sampling
    #'
    #################################################
    # Set the indices inside the bootstrap skeleton #
    #################################################
    for(i in 1:times){
        # Bootstrap the sample
        in_id <- map_int(block_indices, bootstrap_sampling) %>% unname() 
        # Store the bootstrap sample in rset object
        rset$splits[[i]]$in_id <- in_id
        # Remove strata column form data
        rset$splits[[i]]$data <- rset$splits[[i]]$data %>% select(-strata)
    }
    #'
    ##########
    # Return #
    ##########
    return(rset)
}