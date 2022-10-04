source(here::here("R", "packages.R"))
# lapply(packages, library, character.only = TRUE)
tar_option_set(packages = packages,
               garbage_collection = TRUE)
# read custom functions
lapply(list.files(here::here("R"), full.names = TRUE), source)
