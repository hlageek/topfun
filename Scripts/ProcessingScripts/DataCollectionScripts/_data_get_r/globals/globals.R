# read custom functions
lapply(list.files(here::here("R"), full.names = TRUE), source)
tar_option_set(packages = packages())
# obtain configuration from .Renviron
url_csf <- Sys.getenv("URL_CSF")
url_anr_2010 <- Sys.getenv("URL_ANR_2010")
url_anr_2010_p <- Sys.getenv("URL_ANR_2010_P")
url_anr_2009 <- Sys.getenv("URL_ANR_2009")
url_anr_2009_p <- Sys.getenv("URL_ANR_2009_P")
url_eu_europe  <- Sys.getenv("URL_EU_EUROPE")
url_eu_2020 <- Sys.getenv("URL_EU_2020")
url_eu_fp7 <- Sys.getenv("URL_EU_FP7")
url_snsf <- Sys.getenv("URL_SNSF")
