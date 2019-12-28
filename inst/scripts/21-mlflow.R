# https://ropenscilabs.github.io/r-docker-tutorial/

# Helper Functions --------------------------------------------------------
system <- function(command, ...){message(command); base::system(command, ...)}
`%+%` <- function(a,b) paste0(a,b)

# Setup -------------------------------------------------------------------
docker_dir <- tempfile("docker-")
fs::dir_create(docker_dir)
docker_image <- "rocker/verse"
system("docker pull " %+% docker_image, wait = FALSE)

# Launching Docker --------------------------------------------------------
# 1. Run RStudio Server
local_volume <- fs::path_tidy(docker_dir)
container_volume <- "/home/rstudio"
port <- "8787"
command <- 
    "docker run -e PASSWORD=1234 --rm" %+%
    " -p " %+% port %+% ":" %+% port %+%  
    " -v " %+% local_volume %+% ":" %+% container_volume %+% 
    " " %+% docker_image
system(command, wait = FALSE)
browseURL(paste0("http://localhost:", port))
system("docker version")
message("| Username: rstudio | Password: 1234 |")
CONTAINER_ID <- base::system("docker ps -q --latest", intern = TRUE)

# 2. Install Anconda
# install.packages("reticulate")
# reticulate::install_miniconda()

# 3. Install MLflow
# utils::install.packages('mlflow', dependencies = TRUE)
# mlflow::install_mlflow(python_version = "3.7")

# 4. Using MLflow
# https://github.com/mlflow/mlflow/tree/master/mlflow/R/mlflow
# mlflow::mlflow_set_experiment("Test")
# mlflow::mlflow_ui()

# 5. Save the version of the image
COMMIT_MESSAGE <- '\"' %+% "installed mlflow" %+% '\"'
IMAGE_NAME <- "tidylab/mlflow"
command <- "docker commit -m " %+% COMMIT_MESSAGE %+% " " %+% CONTAINER_ID %+% " " %+% IMAGE_NAME
system(command, wait = !FALSE) 
system("docker images") 

# Teardown ----------------------------------------------------------------
# Kill all containers
CONTAINER_IDS <- base::system("docker ps -q", intern = TRUE)
command <- "docker container kill " %+% paste(CONTAINER_IDS, collapse = " ")
system(command)