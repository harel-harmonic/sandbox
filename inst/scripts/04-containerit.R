# Docker Commands ---------------------------------------------------------
# file:///C:/Downloads/Noam_Ross_DockerForTheUseR_nyhackr_2018-07-10.pdf

# Setup -------------------------------------------------------------------
# remotes::install_github("o2r-project/containerit")

# 1. Create a Dockerfile based on a sessionInfo
container <- containerit::dockerfile(utils::sessionInfo())
cat(as.character(containerit::format(container)), sep = "\n")
