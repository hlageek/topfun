list(
  tarchetypes::tar_download(
    name = eu_download_files_zip,
    urls = c(url_eu_europe, url_eu_2020, url_eu_fp7),
    paths = paste0(
        here::here("Data", "OriginalData"), 
        .Platform$file.sep,  
        c("eu_europe", "eu_horizon", "eu_fp7"), 
        ".zip"),
    method = "curl",
    mode = "wb"
  ),
  tar_target(
    name = eu_download_files,
    command = unzip_eu_files(eu_download_files_zip, data_path = here::here("Data", "OriginalData")),
    format = "file" 
  ),
tar_target(
    name = eu_data_raw,
    command = purrr::map_df(eu_download_files, read.csv2) |> 
              dplyr::as_tibble(),
    format = "qs" 
  )
)
