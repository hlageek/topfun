library(targets)

# Load packages and options
source("tar_options.R")

# Load functions
lapply(list.files("R/", full.names = TRUE), source)

# Source targets
source(knitr::purl("tar_plan.Rmd",
                   output = tempfile(),
                   documentation = 0,
                   quiet=TRUE))
targets
