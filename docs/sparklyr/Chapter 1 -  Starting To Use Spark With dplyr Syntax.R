################################################################################
# CHAPTER 1 - Starting To Use Spark With dplyr Syntax                          #
################################################################################
#'
#####################
# 1.0 Chapter setup #
#####################
# Load chapter's libraries
library(sparklyr)
library(pryr)
library(tidyverse)
# Load chapter's data
input_folder <- file.path(getwd(), "data", "raw", "electricity demand")
uk_grid_data <- read_csv(file.path(input_folder, "uk-grid-data.zip"))
uk_weather_data <- read_csv(file.path(input_folder, "london-hourly-weather-data.zip"))
# Preprocess data
uk_elec_dem <- uk_grid_data
#'
###########################################
# 1.1 The connect-work-disconnect pattern #
###########################################
# Connect to the Spark cluster
spark_conn <- spark_connect(master = 'local')

# Print the version of Spark
spark_version(sc = spark_conn)

# Disconnect from Spark
spark_disconnect(sc = spark_conn)
#'
###############################
# 1.2 Copying data into Spark #
###############################
# Explore track_metadata structure
glimpse(uk_elec_dem)

# Connect to the Spark cluster
spark_conn <- spark_connect("local")

# Copy uk_elec_dem into Spark
uk_elec_dem_remote_tbl <- copy_to(spark_conn, uk_elec_dem)

# List the data frames available in Spark
src_tbls(spark_conn)

# Disconnect from Spark
spark_disconnect(spark_conn)
#'
#############################
# 1.3 Big data, tiny tibble #
#############################
# Connect to the Spark cluster
spark_conn <- spark_connect("local")

# Copy uk_elec_dem into Spark
invisible( copy_to(spark_conn, uk_elec_dem) )

# Generate a link to the uk_elec_dem table in Spark
src_tbls(spark_conn) # List the data frames available in Spark
uk_elec_dem_remote_tbl <- tbl(spark_conn, "uk_elec_dem")

# See how big (dimensions-wise) the dataset is
dim(uk_elec_dem_remote_tbl)

# See how small (size-wise) the tibble is
print(object.size(uk_elec_dem_remote_tbl), units = "Kb")

# Compare the remote copy with the local copy
print(object.size(uk_elec_dem), units = "Kb")

# Disconnect from Spark
spark_disconnect(spark_conn)
#'
