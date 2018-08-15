################################################################################
#                                     Main                                     #
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

# Tidy the flu datasets
tidy_datasets <- tidy_flu_datasets(messy_datasets)

# Preprocessing: Standardize columns names
tidy_datasets <- tidy_datasets %>% standardize_columns_names()

# Feature engineering: Add time elements to the flu dataset
tidy_datasets <- tidy_datasets %>% add_dates_elements(col_name = "DATE")


# Fit prediction model at specific location
# fit_regional_model_at <- function(location)
location <- "North Island"

# Subset the dataset
local_data <- tidy_datasets %>% dplyr::filter(LOCATION %in% location)


#

head(tidy_datasets)
