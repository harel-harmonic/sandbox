################################################################################
# Bootstrap metohds for time series                                            #
################################################################################
#'
#' # Introduction
#'
#' There are (at least) four methods:
#'
#' (1) Non-overlapping block bootstrap
#' (2) Overlapping block bootstrap (moving block bootstrap)
#' (3) Stationary block bootstrap
#' (4) Subsampling
#'
#' This scripts contain code for the first and second methods.
#'
#' ---
#'
#' # Bootstrapping Time Series Data: Some Limitations
#'
#' * Problems with sample: non-representative, too small
#' * Problems from dependency structure:
#'     * wrong dependency assumption
#'     * regime changes
#'     * long-term dependency
#'     * overlooked completely
#' * Problems with certain statistics: “Edge” statistics may require many, many
#'   replicates
#' * Finally, Monte Carlo may be better alternative.
#'
#' ---
#'
#' # (2) Moving block bootstrap
#'
#' Moving block Bootstrap preserves the local dependency structure.
#'
#' * Break time series into little blocks.
#' * Resample the blocks, not individual points – kind of "random shuffling,
#'   with replacement.
#' * Within blocks, structure is preserved.
#' * Works if structure between blocks is (quasi) i.i.d.
#'
#########
# Setup #
#########
# Load Project Libraries and Functions
k_path_project <<- rprojroot::find_rstudio_root_file()
source(file.path(k_path_project, "code", "scripts", "setup.R"))
# What is the structure of the time series?
block_quantity <- 24 # There are 24 hours in the time series
block_size <- 6 # There are 6 evenly spread samples within an hour = 10 minutes
n <- block_quantity * block_size # Total number of observations in the series
# How many bootstrap samples to generate?
times <- 10
#'
#################
# Generate data #
#################
dummy_data <- data.frame(
    sample_id = 1:n,
    hour_id = rep(1:block_quantity, each = block_size),
    value = -n:-1
)
# dummy_data <- dummy_data[1:(n - 3), ]
head(dummy_data)
#'
###################
# Sample the data #
###################
set.seed(1135)
rset_1 <- bootstraps_moving_block(
    data = dummy_data,
    times = times,
    block_size = block_size,
    first_split_real_data = TRUE
)
#'
set.seed(1135)
rset_2 <- bootstraps_non_moving_block(
    data = dummy_data,
    times = times,
    block_size = block_size,
    first_split_real_data = TRUE
)
#'
##########################
# Explore the rset object #
###########################
rset_1$splits[[1]] %>% names()
rset_1$splits[[1]]$data
# ----------------------- #
# moving blocks in_id
# ----------------------- #
rset_1$splits[[1]]$in_id
rset_1$splits[[2]]$in_id
# ...
rset_1$splits[[times]]$in_id
# ----------------------- #
# non-moving blocks in_id
# ----------------------- #
rset_2$splits[[1]]$in_id
rset_2$splits[[2]]$in_id
# ...
rset_2$splits[[times]]$in_id
