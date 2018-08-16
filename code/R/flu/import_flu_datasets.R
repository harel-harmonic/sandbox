#' import_flu_datasets
#'
import_flu_datasets <- function() {
    message("---")
    message("Importing flu datasets")

    # Input validation
    assert_all_are_existing("k_path_data_raw")

    # Get all raw CSV files full paths
    files_metadata <- list.files(k_path_data_raw,
        pattern = "*.csv$", full.names = TRUE, recursive = TRUE,
        ignore.case = TRUE
    )

    # Filter only the flu datasets
    files_metadata <- files_metadata[str_detect(files_metadata, "flu-.*\\.csv$")]

    # Create a data frame with the paths and countries' names
    files_metadata <-
        enframe(files_metadata) %>%
        mutate(name = path_file(value) %>%
            str_remove_all("\\.csv") %>%
            str_remove_all("^flu-") %>%
            str_to_title())

    # Read the data files into a list
    flu_data <- list()
    for (k in 1:nrow(files_metadata)) {
        message("-> ", "Importing flu data of ", files_metadata[["name"]][k])
        suppressMessages(
            flu_data[[files_metadata[["name"]][k]]] <-
                read_csv(files_metadata[["value"]][k])
        )
    }

    # Return
    return(flu_data)
}
