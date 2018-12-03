# Install {rmonic}
remotes::install_gitlab(
    repo = "Commonwealth/rmonic@dev", 
    ref = "dev",
    auth_token = "h_Xg3gmq7AFxXz_yRsWZ",
    host = "gitlab.harmonic.co.nz",
    upgrade = TRUE,
    build = FALSE,
    force = FALSE
)

if ("package:rmonic" %in% search()) detach("package:rmonic", unload = TRUE)
library(rmonic)
library(help=rmonic)
# Update {rmonic}
# rmonic::update_rmonic()
