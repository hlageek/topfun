list(
  tar_target(
    name = hal_types,
    command = c("ART", "COUV", "COMM", "OUV")
  ),
  tar_target(
    name = hal_years,
    command = seq(2008, 2012, 1)
  ),
  tar_target(
    name = hal,
    command = call_hal(hal_types, hal_years, run = as.logical(Sys.getenv("API_RUN"))),
    pattern = cross(hal_types, hal_years)

  )
)
