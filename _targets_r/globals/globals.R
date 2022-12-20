# read custom functions and packages
lapply(list.files(here::here("R"), full.names = TRUE), source)
# lapply(packages, library, character.only = TRUE)
tar_option_set(packages = packages(),
               garbage_collection = TRUE)
