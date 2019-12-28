# https://ropenscilabs.github.io/r-docker-tutorial/

# Helper Functions --------------------------------------------------------
system <- function(command, ...){message(command); base::system(command, ...)}
`%+%` <- function(a,b) paste0(a,b)

# Setup -------------------------------------------------------------------
# system("docker system prune -a --volumes") # WARNING: DELETE ALL IMAGES
docker_dir <- tempfile("docker-")
fs::dir_create(docker_dir)
IMAGE_NAME <- "tidylab/tidyflow:3.6.2"

# Launching Docker --------------------------------------------------------
# 1. Build Docker File
dockerfile_path <- file.path(getwd(), "inst", "scripts")
command <- 'docker build --tag="' %+% IMAGE_NAME %+% '"' %+% ' "' %+% dockerfile_path %+% '"'
system(command, wait = !FALSE)

# 2. Show information
command <- "docker history " %+% IMAGE_NAME
system(command, wait = !FALSE)
command <- "docker images"
system(command, wait = !FALSE)

# 3. Run RStudio Server
local_volume <- fs::path_tidy(docker_dir)
container_volume <- "/home/rstudio"
port <- "8787"
command <- 
    "docker run -e PASSWORD=1234 --rm" %+%
    " -p " %+% port %+% ":" %+% port %+%  
    " -v " %+% local_volume %+% ":" %+% container_volume %+% 
    " " %+% IMAGE_NAME
system(command, wait = FALSE)
browseURL(paste0("http://localhost:", port))
system("docker version")
message("| Username: rstudio | Password: 1234 |")
CONTAINER_ID <- base::system("docker ps -q --latest", intern = TRUE)

# 4. Using MLflow
# https://github.com/mlflow/mlflow/tree/master/mlflow/R/mlflow
# mlflow::mlflow_set_experiment("Test")
# mlflow::mlflow_ui()

# Teardown ----------------------------------------------------------------
# Kill all containers
CONTAINER_IDS <- base::system("docker ps -q", intern = TRUE)
command <- "docker container kill " %+% paste(CONTAINER_IDS, collapse = " ")
system(command)

# Push Image
command <- "docker push " %+% IMAGE_NAME
system(command)
