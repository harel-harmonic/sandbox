#' fit_regional_flu_models
#' 
#' 
fit_regional_flu_models <- function(roll_rs){
    # Input validation
    stopifnot(!missing(roll_rs), "rset" %in% class(roll_rs))
    
    # Define model
    fit_model <- function(data){
        
        mdl <- lm(INDEX ~ YEAR_DAY, 
                  data = data, 
                  na.action = "na.omit")
        
    }# fit_model
    
    # Fit regional models
    mdls <- map(roll_rs$splits, fit_model)
    
    # Return
    return(mdls)
}