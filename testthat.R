###########
## Setup ##
###########
path_project <- rprojroot::find_rstudio_root_file()
path_temp <- file.path(path_project, "temp")
path_functions <- file.path(path_project, "R")


###########################
## Load Project Packages ##
###########################
library(testthat)
library(tidyverse)
library(lubridate)
library(assertive)
library(rpart)


############################
## Load Project Functions ##
############################
source(file.path(path_functions, "load_functions.R"))
load_functions(path_functions)


################
## Unit Tests ##
################
local({
    message(rep("#",40), "\n## Running Unit Tests\n", rep("#",40))
    test_dir(file.path(path_project, "tests", "testthat"))
})


#####################
## Component Tests ##
#####################
local({
    message(rep("#",40), "\n## Running Component Tests\n", rep("#",40))
    test_dir(file.path(path_project, "tests", "component-tests"))
})


#############
## Cleanup ##
#############
suppressWarnings(rm(path_project, path_functions, path_temp))
unlink(path_temp, recursive = TRUE, force = TRUE)
