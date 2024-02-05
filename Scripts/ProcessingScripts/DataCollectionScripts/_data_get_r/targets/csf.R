list(
   tarchetypes::tar_download(
    name = csf_download_files,
    urls = url_csf,
    paths = here::here("Data", "OriginalData", "csf.tsv")
  )
)
