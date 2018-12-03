################################################################################
##                               Model Launcher                               ##
################################################################################
# Model Functions:
# 1. model_init
# 2. model_fit
# 3. model_predict
# 4. model_log
# 5. model_end

# Load project libraries
library(rmonic)
library(datasets)
library(tidyverse)
library(rsample)

# Get the Dataset
dataset <- mtcars

# Add UID column
dataset <- dataset %>% rownames_to_column("UID")

# Split the Dataset into 10 Folds
set.seed(422)
rsample_object <- vfold_cv(dataset, v = 10)

# Exract the data from the folds into training and test sets
k <- 1
training_set <- rsample::training(rsample_object$splits[[k]])
test_set <- rsample::testing(rsample_object$splits[[k]])
assertive::assert_are_disjoint_sets(training_set, test_set)

# Fit a model to the training folds and predict the test fold
list_of_models <- rmonic::model_fit(training_set)
list_of_predictions <- rmonic::model_predict(test_set, list_of_models)
list_of_predictions[[1]]
training_set



