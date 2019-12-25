# Setup -------------------------------------------------------------------
# remotes::install_github("colinfay/dockerfiler")
# remotes::install_github("wch/harbor")
get_docker <- function(Dockerfile){
    file_path <- tempfile("docker")
    docker01$write(file_path)
    shell.exec(dirname(file_path))
    message("Saved commends to ", basename(file_path))
}

# Docker Commands ---------------------------------------------------------
# https://ropenscilabs.github.io/r-docker-tutorial/02-Launching-Docker.html
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
system("docker run -e PASSWORD=1234 --rm -p 8787:8787 rocker/verse")
browseURL("http://localhost:8787")
message("| Username: rstudio | Password: 1234 |")

# 5. Kill all containers
CONTAINER_IDS <- system("docker ps -q", intern = TRUE)
system(paste("docker container kill", CONTAINER_IDS, collapse = " "))

# 01 Simple Docker File ---------------------------------------------------
file_path <- tempfile(fileext = ".docker")
docker01 <- dockerfiler::Dockerfile$new()
docker01$write(file_path)
paste("docker build", fs::path_tidy(dirname(file_path)), "-f", basename(file_path))  
shell.exec(dirname(file_path))


# harbor::docker_run(image = "docker01", cmd = docker01$print(), capture_text = TRUE)
# 
command <- "docker run -it -d"

paste(command, fs::path_tidy(dirname(file_path)), "-f", basename(file_path))  
