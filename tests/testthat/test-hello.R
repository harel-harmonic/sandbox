context("test-hello")

test_that("outputs a greeting message on the console", {
    ###########
    ## Setup ##
    ###########
    expect_false(exists("first_name"))
    
    
    #############################
    ## Invalid Input Arguments ##
    #############################
    ## No input arguments
    expect_error(hello())
    
    
    ###########################
    ## Valid Input Arguments ##
    ###########################
    expect_message(hello(first_name = "Bilbo"), "Hello Bilbo")
})
