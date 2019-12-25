# Setup -------------------------------------------------------------------
# remotes::install_github("colinfay/dockerfiler")
get_docker <- function(Dockerfile){
    file_path <- tempfile("docker")
    docker01$write(file_path)
    shell.exec(dirname(file_path))
    message("Saved commends to ", basename(file_path))
}

# 01 Simple Docker File ---------------------------------------------------
docker01 <- dockerfiler::Dockerfile$new()
get_docker(docker01)


