################################################################################
# Preparing data for analysis: Managing categorical values                     #
################################################################################
#'
#########
# Setup #
#########
#' Load project's libraries
library(tidyverse)
library(vtreat)
#'
# ---------------------------------------------------------------------------- #
# 2.3. Novel categorical levels and indicators                                 #
# ---------------------------------------------------------------------------- #
#' Example @[p. 7]
#' 1. Generate the train and test sets 
train_set <- data.frame(x = c('a', 'a', 'b', 'b', 'c', 'c'), 
                        y = c(  1,   2,   3,   4,   5,   6),
                        stringsAsFactors = FALSE)

test_set <- data.frame(x = c('a', 'b', 'c', 'd'), 
                       stringsAsFactors = FALSE) 

#' 2. Fit model on the train set
model <- lm(y ~ x, data = train_set)

#' 3. Predict the test set
tryCatch(predict(model, newdata = test_set),
         error = function(e) print(strwrap(e)))

#' 4. Represent categorical variables as indicators.

#' 4.1 In {stats}
model.matrix(~train_set$x + 0) 

#' 4.2 In {vtreat}

#' 4.2.1 Use vtreat::designTreatments* to collect statistics on a data.frame and
#' produce a treatment plan
treatplan <- designTreatmentsN(dframe = train_set,
                               varlist = 'x',
                               outcomename = 'y')
class(treatplan)
treatplan %>% names()

scoreFrame <- treatplan[["scoreFrame"]]
class(scoreFrame)
scoreFrame %>% names()
print(scoreFrame %>% as.tibble())

varnames <- scoreFrame %>% dplyr::filter(code %in% "lev") %>% .$varName
print(varnames)

#' 4.2.2 Use the treatment plan to process subsequent data.frames for model 
#'       training and model application, via the function vtreat::prepare.
test_set_treat <- prepare(treatmentplan = treatplan,
                          dframe = test_set,
                          pruneSig = NULL, 
                          varRestriction = varnames)
#'
# ---------------------------------------------------------------------------- #
# 2.4. High-cardinality categorical variables                                  #
# ---------------------------------------------------------------------------- #
#' A. Look-up codes @[p. 9]
#'
#' B. Impact or effects coding @[p. 10]
#' Example @[p. 10], a regression problem with:
#' * 2 numeric inputs (one signal sigN, one noise, noiseN), and 
#' * 2 high-cardinality, with 100 levels, categoric inputs 
#'   (one signal, sigC, and one noise, noiseC).
#'
#' 1. Create “zip code”, a variable that takes one of 25 possible values
set.seed(235)
Nz <- 25
zip <- paste0('z', format(1:Nz, justify="right"))
zip <- gsub(' ', '0', zip, fixed=TRUE)
zipval <- 1:Nz
names(zipval) <- zip

#' 2. Set the first 3 zip codes to account for 80% of the data
n <- 3
m <- Nz - n 
p <- c(numeric(n) + (0.8/n), numeric(m) + 0.2/m)
N <- 1000
#' 2.1 Draw zipcode means with replacement
zipvar <- sample(zip, N, replace=TRUE, prob=p)
#' 2.2 Add noise to the zipcode mean
signal <- zipval[zipvar] + rnorm(N) 

#' 3.Create the data set
d <- data.frame(zip = zipvar, y = signal + rnorm(N))

#' 4. Impact-code the zip code variable
#' 4.1 Use vtreat::designTreatments* to collect statistics on a data.frame and
#' produce a treatment plan
treatplan <- designTreatmentsN(dframe = d, varlist = "zip", outcome = "y")
class(treatplan)
names(treatplan)
treatplan$meanY # The treatment plan includes the observed mean of the outcome

scoreFrame <- treatplan[["scoreFrame"]] # information about the derived vars.
class(scoreFrame)
scoreFrame %>% names()
scoreFrame %>% 
    as.tibble() %>% 
    select('varName', 'sig', 'extraModelDegrees', 'origName', 'code') %>%
    print()

#' 4.2 Use the treatment plan to process subsequent data.frames for model 
#'       training and model application, via the function vtreat::prepare.
vars <- scoreFrame$varName[!(scoreFrame$code %in% c("catP", "catD"))]
dtreated <- prepare(treatplan, d, pruneSig=NULL, varRestriction=vars)
head(dtreated %>% add_column(Y_mean = treatplan$meanY, .before=1))
