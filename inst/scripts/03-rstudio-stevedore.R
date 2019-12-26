# Docker Commands ---------------------------------------------------------
# file:///C:/Downloads/Noam_Ross_DockerForTheUseR_nyhackr_2018-07-10.pdf

# Setup -------------------------------------------------------------------
# remotes::install_github("richfitz/stevedore")
# remotes::install_github("rstudio/reticulate")
# remotes::install_github("o2r-project/containerit")

# py_ver <- stringr::str_extract(system("python --version", TRUE), "[2-3].[0-9].[0-9]|[2-3].[0-9]")
# reticulate::conda_install(packages = "docker", pip = TRUE, python_version = py_ver, force)
reticulate::virtualenv_create("docker")
reticulate::use_virtualenv("docker")

# 1. Create docker client
docker <- stevedore::docker_client()
docker