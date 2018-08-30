#' bootstraps_moving_block
#'
#' @param first_split_real_data a logical. If TRUE (default), the first split is
#' the original (unsampled) data.
#'
bootstraps_moving_block <- function(data,
                                    times = 25,
                                    block_size,
                                    first_split_real_data = TRUE) {
    ####################
    # Input validation #
    ####################
    stopifnot(!missing(data), !missing(block_size))
    assert_is_data.frame(data)
    assert_all_are_positive(c(times, block_size))
    assert_is_logical(first_split_real_data)
    #'
    #########
    # Setup #
    #########
    n <- nrow(data)
    block_quantity <- ceiling(n / block_size)
    #'
    #############################
    # Create bootstrap skeleton #
    #############################
    # Create a strata variable which associates instances and blocks
    strata <- rep(1:block_quantity, each = block_size)
    # In case one of the blocks isn't fully populated, make sure it's the
    # first-block (rather than the last block)
    m <- block_quantity * block_size
    strata <- strata[(m - n + 1):m]
    # Add strata column to the data
    data <- data %>% add_column(strata = strata, .before = 1)
    # Create the skeleton for the time series bootstrap
    rset <- rsample::bootstraps(data, times, "strata")
    #'
    ##########################
    # Moving block bootstrap #
    ##########################
    # Find the indices of each block
    block_indices <- sapply(
        1:(n - block_size + 1),
        function(x) seq.int(from = x, to = x + (block_size - 1))
    )
    block_indices <- t(block_indices)
    # Complement the last incomplete blocks
    block_indices <- rbind(
        block_indices,
        block_indices[rep(nrow(block_indices), block_size - 1), ]
    )
    # Revert the prevalence of the observation. This makes sure the freshest
    # observations are not available for bootstrap sampling before they have
    # appeared
    block_indices <- max(block_indices) + 1 - block_indices
    block_indices <- block_indices[nrow(block_indices):1, ncol(block_indices):1]
    # Convert data frame to list
    block_indices <- split(block_indices, block_indices %>% nrow() %>% seq())
    #'
    ########################
    # Bootstrap the sample #
    ########################
    bootstrap_sampling <- function(x, ...) {
        if (length(x) == 1) { # if the sample size is one, then return the sample value
            x
        } else { # else sample with replacement
            base::sample(x, 1, replace = TRUE)
        }
    } # bootstrap_sampling
    #'
    #################################################
    # Set the indices inside the bootstrap skeleton #
    #################################################
    for (i in 1:times) {
        # Bootstrap the sample
        in_id <- map_dbl(block_indices, bootstrap_sampling) %>% unname()
        # Store the bootstrap sample in rset object
        rset$splits[[i]]$in_id <- in_id %>% as.integer()
        # Remove strata column form data
        rset$splits[[i]]$data <- rset$splits[[i]]$data %>% select(-strata)
    }
    # Should the unsampled data be retained in the first split?
    if (first_split_real_data) {
          rset$splits[[1]]$in_id <- 1:n
      }
    #'
    ##########
    # Return #
    ##########
    return(rset)
}
