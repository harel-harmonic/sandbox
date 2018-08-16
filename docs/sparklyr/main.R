################################################################################
#                                    Main                                      #
################################################################################
#'
#########
# Setup #
#########
# Run generic setup
k_path_project <<- rprojroot::find_rstudio_root_file()
source(file.path(k_path_project, "code", "scripts", "setup.R"))
# Install a local version of Spark for development purposes
if(nrow(spark_installed_versions()) == 0)
    spark_install(version = "2.3.0")
