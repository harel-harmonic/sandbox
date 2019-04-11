context("integration-test-fitting-a-model")

# Helper functions -------------------------------------------------------------
model_eval <- function(y, y_hat) return(RMSE = sqrt(mean((y - y_hat)^2)))

# compare white-box and black-box ----------------------------------------------

test_that("white-box prodces similar results as black-box", {
    ## Get the data
    D <- mtcars
    
    ## Split the data
    set.seed(1020)
    index_train <- sample(1:NROW(D), round(NROW(D) * 0.7))
    X_tr <- D[index_train, -1]
    y_tr <- D[index_train, +1]
    X_te <- D[-index_train, -1]
    y_te <- D[-index_train, +1]
    
    ## Get blackbox results
    y_hat_bb <- blackbox(X_tr, y_tr, X_te)
    
    ## Compare outputs
    expect_equal(y_hat_bb, y_hat_wb, check.attributes = FALSE)
})

# compare white-box can fit a decision tree ------------------------------------
# 
# test_that("white-box produces similar results as black-box", {
#     
# })