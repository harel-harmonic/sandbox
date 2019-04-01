################################################################################
##                             Model Backtesting                              ##
################################################################################
#' WARNINGR:
#' Researching and backtesting is like drinking and driving.
#' Do not research under the influence of a backtest.
rmonic::setup()
rmonic::list_to_env(yaml::read_yaml(file.path(k_path_scripts, "backtesting.yml")))


######################################
## Fetch the Correct Model Launcher ##
######################################
if(allow_parallel){
    source(file.path(k_path_scripts, "backtesting-parallel.R"))
} else {
    source(file.path(k_path_scripts, "backtesting-sequential.R"))
}
