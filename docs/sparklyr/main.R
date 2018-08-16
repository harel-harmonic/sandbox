################################################################################
#                                    Main                                      #
################################################################################
#'
#####################
# Inputs validation #
#####################
k_path_project <<- rprojroot::find_rstudio_root_file()
source(file.path(k_path_project, "code", "scripts", "setup.R"))
