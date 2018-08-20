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
# Install java
if(!nchar(Sys.getenv("JAVA_HOME"))){
    Sys.setenv(JAVA_HOME = file.path("C:","Program Files","Java","jre1.8.0_181"))
    browseURL("https://www.java.com/en/")
}


