#' Standardize columns names
#'
standardize_columns_names <- function(data) {
    # Input validation
    stopifnot(!missing(data))
    assert_is_data.frame(data)

    # Standardize columns names
    colnames(data) <-
        data %>%
        colnames() %>%
        # Transform columns names to upper case
        str_to_upper() %>%
        # Transform columns names separators to under scores
        str_replace_all(" |\\.", "_")

    # Return
    return(data)
}
