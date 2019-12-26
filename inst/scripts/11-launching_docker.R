# https://ropenscilabs.github.io/r-docker-tutorial/
# Setup -------------------------------------------------------------------
docker_dir <- tempfile("docker-")
fs::dir_create(docker_dir)
fs::file_create(docker_dir, "demo.text")
shell.exec(docker_dir)

# Launching Docker --------------------------------------------------------
# 1. See available docker commands
system("docker")

# 2. List available docker images on the machine
system("docker images")

# 3. Get R image from Docker Hub
system("docker pull rocker/verse")

# 4. Run RStudio Server
local_volume <- fs::path_tidy(docker_dir)
container_volume <- "/home/rstudio"
port <- "8787"
command <- paste0("docker run -e PASSWORD=1234 --rm",
                  " -p ", port, ":", port, 
                  " -v ", local_volume, ":", container_volume,
                  " rocker/verse")
message(command)
system(command, wait = FALSE)
browseURL(paste0("http://localhost:", port))
message("| Username: rstudio | Password: 1234 |")

# Teardown ----------------------------------------------------------------
# Kill the latest containers
CONTAINER_ID <- system("docker ps -q --latest", intern = TRUE)
system(paste("docker container kill", CONTAINER_ID, collapse = " "))
