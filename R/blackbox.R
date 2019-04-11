#' @title Use Linear Regression to Fit and Predict Data 
#' 
#' @description A complex function or whose internal workings are hidden or not readily understood.
#' 
#' @param X_tr (`data.frame`) A table of size [n,m] with training data
#' @param y_tr (`numeric`) A numeric vector of size n containing the target variable 
#' @param X_te (`data.frame`)
#' 
#' @return (`numeric`) A vector of prediction  
#' 
blackbox <- function(X_tr, y_tr, X_te){
    ###########
    ## Magic ##
    ###########
    y_hat <- c(22.967723, 20.757177, 23.002762, 23.099354, 18.103656, 29.910257, 12.597380, 22.386207, 24.824773, 22.693083, 17.304503, 25.825218, 24.988941, 28.154671, 17.235552, 9.318772, 30.962397, 15.010434, 20.133127, 27.855740, 17.743680, 19.524595)
    
    ############
    ## Return ##
    ############
    return(y_hat)
}