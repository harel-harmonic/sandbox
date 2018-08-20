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
#'
###########################################
# 1.1 The connect-work-disconnect pattern #
###########################################
# Connect to your Spark cluster
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
str(mtcars)

# Connect to your Spark cluster
spark_conn <- spark_connect("local")

# Copy track_metadata to Spark
mtcars_remote_tbl <- copy_to(spark_conn, mtcars)

# List the data frames available in Spark
src_tbls(spark_conn)

# Disconnect from Spark
spark_disconnect(spark_conn)
#'
###############################
# 1.3 Copying data into Spark #
###############################




# Explore track_metadata structure
str(mtcars)

# Connect to your Spark cluster
spark_conn <- spark_connect("local")

# List the data frames available in Spark
src_tbls(spark_conn)

# Copy mtcars to Spark database
# Notice: mtcars_remote_tbl is a tibble that doesn't contain any data of its 
#         own. Instead, it links to a data stored on the Spark database.
mtcars_remote_tbl <- copy_to(spark_conn, mtcars, overwrite = TRUE)
# OR in two steps:
# copy_to(spark_conn, mtcars, overwrite = TRUE)
# mtcars_local_tbl <- tbl(spark_conn, "mtcars", overwrite = TRUE)

# See how big the local copy of the dataset copy is
dim(mtcars_remote_tbl)

# See how small the tibble is
pryr::object_size(mtcars_remote_tbl)

#'







# Disconnect from Spark
spark_disconnect(spark_conn)





