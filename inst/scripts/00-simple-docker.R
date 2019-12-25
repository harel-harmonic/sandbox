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
# 1. See available docker commands
system("docker")
# 2. List available docker images on the machine
system("docker images")
# 3. Get R image from Docker Hub
system("docker pull rocker/verse")
# 4. Run RStudio Server
system("docker run -e PASSWORD=1234 --rm -p 8787:8787 rocker/verse")
browseURL("http://127.0.0.1:8787")
message("| Username: rstudio | Password: 1234 |")





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
