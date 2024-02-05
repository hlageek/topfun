list(
  tarchetypes::tar_download(
    name = anr_download_files,
    urls = c(url_anr_2010, url_anr_2009, url_anr_2010_p, url_anr_2009_p),
    paths = paste0(
        here::here("Data", "OriginalData"), 
        .Platform$file.sep,  
        c("anr_2010", "anr_2009", "anr_2010_p", "anr_2009_p"), 
        ".csv")
  ),
  tar_target(
    name = anr_data_raw_2010,
    command = readr::read_delim(anr_download_files[1],
                                 delim = ";",
                                 locale = locale("fr",
                                                 decimal_mark = "."),
                                                 show_col_types = FALSE) |> 
                                                 janitor::clean_names()|> 
                                                 dplyr::mutate(source = "since2010"),
    format = "qs"
  ),
  tar_target(
    name = anr_data_raw_2009,
    command = readr::read_delim(anr_download_files[2],
                                 delim = ";",
                                 locale = locale("fr",
                                                 decimal_mark = "."),
                                show_col_types = FALSE) |> 
                                                 janitor::clean_names() |> 
                                                 dplyr::mutate(source = "before2009"),
    format = "qs"
  ),
  tar_target(
    name = anr_data_raw,
    command = dplyr::bind_rows(
        anr_data_raw_2010,
        anr_data_raw_2009
    ),
    format = "qs"
  )
)
