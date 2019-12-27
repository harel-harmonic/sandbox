# https://ropenscilabs.github.io/r-docker-tutorial/

# Helper Functions --------------------------------------------------------
system <- function(command, ...){message(command); base::system(command, ...)}
`%+%` <- function(a,b) paste0(a,b)

# Setup -------------------------------------------------------------------
docker_dir <- tempfile("docker-")
fs::dir_create(docker_dir)
Rprofile <- ".First <- function(){print(\"system('python --version')\")}"
writeLines(Rprofile, file.path(docker_dir, ".Rprofile"))
# shell.exec(docker_dir)

# Launching Docker --------------------------------------------------------
docker_image <- "rocker/verse"
system("docker pull " %+% docker_image, wait = FALSE)
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
message("| Username: rstudio | Password: 1234 |")
CONTAINER_ID <- base::system("docker ps -q --latest", intern = TRUE)

# 2. Install an R Package on the Container
# utils::install.packages('h2o')

# 3. Install Python 3
command <- "winpty docker exec -it " %+% CONTAINER_ID %+% " bash"
system(command, wait = !FALSE)

command <- "apt-get update"
system(command, wait = !FALSE)

command <- "apt-get install python3"
system(command, wait = !FALSE)

# 4. Save the version of the image
COMMIT_MESSAGE <- '\"' %+% "installed h2o" %+% '\"'
IMAGE_NAME <- "rocker/h2o"
command <- "docker commit -m " %+% COMMIT_MESSAGE %+% " " %+% CONTAINER_ID %+% " " %+% IMAGE_NAME
system(command, wait = FALSE) 
system("docker images") 

# Teardown ----------------------------------------------------------------
# Kill all containers
CONTAINER_IDS <- base::system("docker ps -q", intern = TRUE)
command <- "docker container kill " %+% paste(CONTAINER_IDS, collapse = " ")
system(command)