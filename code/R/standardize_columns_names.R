#' Standardize columns names
#'
standardize_columns_names <- function(data) {
    # Input validation
    stopifnot(!missing(data))
    assert_is_data.frame(data)
    
    # Helper functions
    local({
        split_camelcase <- function(string){
            for(k in 1:length(string)){
                # Check if all letters are upper case
                if(string[[k]] == toupper(string[[k]])) next
                # Seperate camelcase words
                string[[k]] <- gsub("([A-Z])", " \\1", string[[k]])
                # Connect cappital letters
                string[[k]] <- gsub(paste0("(?:(?=\\b(?:\\p{Lu}\\h+){2}\\p{Lu})|", "\\G(?!\\A))\\p{Lu}\\K\\h+(?=\\p{Lu})"), "", string[[k]], perl = TRUE)
                # Remove extra spaces
                string[[k]] <- gsub("^ *|(?<= ) | *$", "",  string[[k]], perl = TRUE)
            }
            return(string)
        }
    })
    
    # Standardize columns names
    colnames(data) <-
        data %>%
        colnames() %>%
        # Transform camelcase names to separat words
        str_replace_all("_|\\.", " ") %>%
        split_camelcase() %>%
        # Transform columns names to upper case
        str_to_upper() %>%
        # Transform columns names separators to under scores
        str_replace_all(" |\\.", "_")
    
    # Return
    return(data)
}
