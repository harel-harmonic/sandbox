################################################################################
#                                     Flu                                      #
################################################################################
#' GitHub webpage
#' <https://ropensci.github.io/drake/>
#'
#' The drake R Package User Manual
#' <https://ropenscilabs.github.io/drake-manual/index.html#the-drake-r-package>
#'
#####################
# Inputs validation #
#####################
k_path_project <<- rprojroot::find_rstudio_root_file()
source(file.path(k_path_project, "code", "scripts", "setup.R"))
#'
#######
# ??? #
#######
# Import flu datasets
messy_datasets <- import_flu_datasets()

# Tidy and consolidate the flu datasets
tidy_datasets <- tidy_flu_datasets(messy_datasets)

# Preprocessing: Standardize columns names
tidy_datasets <- tidy_datasets %>% standardize_columns_names()

# Feature engineering: Add time elements to the flu dataset
tidy_datasets <- tidy_datasets %>% add_dates_elements(col_name = "DATE")


# Fit prediction model at specific location
data <- tidy_datasets
location <- "North Island"

# Get regional data rolling sample
local_rolling_sample <- get_regional_data_rolling_sample(data, location)

# Fit modles on regional data rolling sample
local_models <- fit_regional_flu_models(roll_rs = local_rolling_sample)

# Predict regional flu index
local_predictions_list <-
    predict_regional_flu_models(
        roll_rs = local_rolling_sample,
        roll_mdls = local_models
    )

# Bind Splits
local_predictions_df <- bind_lists(data = local_predictions_list)
