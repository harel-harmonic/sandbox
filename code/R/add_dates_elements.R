#' add_dates_elements
#'
#' @param data a data frame
#' @param col_name a string specifying the date col name
#'
add_dates_elements <- function(data, col_name = "DATE") {
    # Input validation
    stopifnot(!missing(data))
    assert_all_are_non_missing_nor_empty_character(col_name)
    assert_is_data.frame(data)
    assert_is_subset(col_name, colnames(data))
    assert_is_date(data[, col_name])

    # Store the original col names
    col_names <- colnames(data)

    # Expend the data frame with date elements
    data <-
        data %>%
        mutate(
            YEAR = lubridate::year(.[[col_name]]),
            MONTH = lubridate::month(.[[col_name]]),
            WEEK_DAY = lubridate::wday(.[[col_name]], label = TRUE),
            YEAR_DAY = lubridate::yday(.[[col_name]])
        )

    # Organize the columns names
    col_names <- append(
        x = col_names,
        values = c("YEAR", "MONTH", "WEEK_DAY", "YEAR_DAY"),
        after = which(col_names %in% col_name)
    )
    data <- data %>% select(col_names)


    # Return
    return(data)
}
