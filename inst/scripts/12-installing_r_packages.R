# https://ropenscilabs.github.io/r-docker-tutorial/

# Helper Functions --------------------------------------------------------
system <- function(command, ...){message(command); base::system(command, ...)}
`%+%` <- function(a,b) paste0(a,b)

# Setup -------------------------------------------------------------------
docker_dir <- tempfile("docker-")
fs::dir_create(docker_dir)
# Rprofile <- ".First <- function(){.First.sys(); if(!'beepr' %in% rownames(installed.packages())) utils::install.packages('beepr')}"
# writeLines(Rprofile, file.path(docker_dir, ".Rprofile"))
# shell.exec(docker_dir)

# Launching Docker --------------------------------------------------------
# 1. Run RStudio Server
local_volume <- fs::path_tidy(docker_dir)
container_volume <- "/home/rstudio"
port <- "8787"
command <- 
    "docker run -e PASSWORD=1234 --rm" %+%
    " -p " %+% port %+% ":" %+% port %+%  
    " -v " %+% local_volume %+% ":" %+% container_volume %+% 
    " rocker/verse"
message(command)
system(command, wait = FALSE)
browseURL(paste0("http://localhost:", port))
message("| Username: rstudio | Password: 1234 |")

# 2. Install an R Package on the Container


# Teardown ----------------------------------------------------------------
# Kill all containers
CONTAINER_IDS <- base::system("docker ps -q", intern = TRUE)
command <- "docker container kill " %+% paste(CONTAINER_IDS, collapse = " ")
system(command)