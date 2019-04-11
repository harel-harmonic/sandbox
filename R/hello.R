#' @title Greet the User
#' 
#' @param first_name (`character`) The user first name
#' 
#' @return NULL; prints the user name in the console
#' 
hello <- function(first_name){
    msg <- paste("Hello", first_name)
    message(msg)
    return(NULL)
}