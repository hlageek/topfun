list(
  tarchetypes::tar_download(
    name = snsf_download_files,
    urls = c(url_snsf),
    paths = paste0(
        here::here("Data", "OriginalData"), 
        .Platform$file.sep,  
        c("snsf"), 
        ".csv"),
    method = "curl",
    mode = "w"
  ),
tar_target(
    name = snsf_data_raw,
    command = read.csv2(snsf_download_files)|> 
              dplyr::as_tibble(),
    format = "qs" 
  )
)
