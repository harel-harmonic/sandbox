################################################################################
#                                    mtcars                                    #
################################################################################
#'
#####################
# Inputs validation #
#####################
k_path_project <<- rprojroot::find_rstudio_root_file()
source(file.path(k_path_project, "code", "scripts", "setup.R"))
pkgconfig::set_config("drake::strings_in_dots" = "literals")
k_path_drake_mtcars <<- file.path(k_path_documents, "drake", "mtcars")
source(file.path(k_path_drake_mtcars, "plan.R"))
#'
# Optionally plot the graph of your workflow.
config <- drake_config(my_plan) # nolint
vis_drake_graph(config) # nolint

# Now it is time to actually run your project.
make(my_plan) # Or make(my_plan, jobs = 2), etc.

# Now, if you make(whole_plan) again, no work will be done
# because the results are already up to date.
# But change the code and some targets will rebuild.

# Read the output report.md file
# for an overview of the project and the results.
