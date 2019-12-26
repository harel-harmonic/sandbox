# Setup -------------------------------------------------------------------
docker_dir <- tempfile("docker-")
fs::dir_create(docker_dir)
fs::file_create(docker_dir, "demo.txt")
shell.exec(docker_dir)

# Docker Commands ---------------------------------------------------------
# 1. See available docker commands
system("docker")

# 2. List available docker resources
# 2.1. List available docker images on the machine
system("docker images")
# 2.2. List available docker containers on the machine
system("docker ps")

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

# 5. Kill all containers
CONTAINER_IDS <- system("docker ps -q", intern = TRUE)
system(paste("docker container kill", CONTAINER_IDS, collapse = " "))