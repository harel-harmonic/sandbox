FROM rocker/tidyverse:3.6.2

RUN R -e 'utils::install.packages("reticulate")'
RUN R -e 'reticulate::install_miniconda()'

RUN R -e 'utils::install.packages("mlflow", dependencies = TRUE, repos = "https://cran.rstudio.com/")'
RUN R -e 'mlflow::install_mlflow(python_version = "3.7")'