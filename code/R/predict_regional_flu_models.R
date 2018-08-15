#' predict_regional_flu_models
#'
#'
predict_regional_flu_models <- function(roll_rs, roll_mdls){
    # Input validation
    stopifnot(!missing(roll_rs), !missing(roll_mdls),
              "rset" %in% class(roll_rs), "list" %in% class(roll_mdls))
    
    # Get assessment data
    assessment_datasets <- assessment(roll_rs)

    # Define model
    predict_model <- function(split, mdl){
        
        # Predict new data
        y_hat <- predict(mdl, split)
        n <- length(y_hat)

        # Append the date and real value to the predicted value
        Y <- data.frame(
            DATE = head(split$data$DATE, n),
            Y = head(split$data$INDEX, n),
            Y_HAT = y_hat)
        
        # Rerutn
        return(Y)
    }
    
    # Fit regional models
    flu_predictions <- map2(assessment_datasets$splits, roll_mdls, predict_model)
    
    # Rerutn
    return(flu_predictions)
}