# read custom functions
lapply(list.files(here::here("R"), full.names = TRUE), source)
tar_option_set(packages = packages())
