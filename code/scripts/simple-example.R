################################################################################
##                                googlesheets                                ##
################################################################################
######################
## Helper Functions ##
######################
# gs_connect -------------------------------------------------------------------
#
#' @title Create a Connection to a googlesheet
#' @param x The sheet key, e.g. "1w2GNG-L3nGET69HUytKgUFOtPGM7lzQTZPYG5Y8esjI".
gs_connect <- function(x){
    ## Authenticate Google account
    googlesheets::gs_auth(new_user = FALSE)
    ## Establish a connection
    con <- googlesheets::gs_key(x)
    options("gs_connection" = con)
}
#
# move_records_between_sheets --------------------------------------------------
#
#' @title Move Records Between Sheets
#' @description The function cut-paste records from one sheet to another
#' @param ws_source The sheet name from which the records will be taken
#' @param ws_target The sheet name in which the records will be stored
move_records_between_sheets <- function(ws_source, ws_target, index_source){
    ## Get source sheet data
    ss <- getOption("gs_connection")
    source_sheet <- googlesheets::gs_read(ss, ws = ws_source)

    ## Data Processing
    ### Slice the source data
    records <- source_sheet %>% dplyr::slice(index_source)
    ### Add timestamp
    records <- records %>% tibble::add_column(timestamp = Sys.Date(), .before = 0)
    
    ## Append records to target sheet
    googlesheets::gs_add_row(ss, ws_target, records)
    
    ## Delete records from source sheet
    records <- source_sheet %>% dplyr::slice(-index_source)
    googlesheets::gs_edit_cells(ss, ws_source, records, byrow = TRUE, trim = TRUE)
}


###########
## Setup ##
###########
library(googlesheets)
## Establish a connection with a google sheet
gs_connect("1w2GNG-L3nGET69HUytKgUFOtPGM7lzQTZPYG5Y8esjI")


#################
## Add Records ##
#################
random_car <- mtcars[sample(32,1),] %>% tibble::rownames_to_column() %>% tibble::add_column(action = "?")
gs_add_row(getOption("gs_connection"), "To Review", random_car)


########################
## Do Nothing Records ##
########################
## Move "Do Nothing" records from "To Review" tab into "Done" tab
### Find which records were classified as "Do Nothing"
tab_to_review <- gs_read(ss = getOption("gs_connection"), ws = "To Review")
index_move_to_done <- which(tab_to_review$action %in% "Do Nothing")
### Cut-Paste records between sheets
try(move_records_between_sheets(ws_source = "To Review", ws_target = "Done", index_source = index_move_to_done))