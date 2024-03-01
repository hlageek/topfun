#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param osf_url
#' @param osf_folder
#' @return
#' @author hlageek
#' @export
osf_get_info <- function(osf_url = NULL, osf_folder = "input_data") {
  osfr::osf_auth(Sys.getenv("OSF_PAT"))
  osf_project <- osfr::osf_retrieve_node(osf_url)
  osf_files <- osfr::osf_ls_files(osf_project, path = osf_folder, n_max = Inf)
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param osf_info
#' @param local_folder
#' @return
#' @author hlageek
#' @export
osf_get_files <- function(osf_info, local_folder) {
  files <- osf_info$meta |>
    purrr::map("attributes") |>
    purrr::map_chr("name")
  osf_downloads_df <- osfr::osf_download(osf_info, here::here(local_folder),
    verbose = TRUE,
    conflicts = "overwrite"
  )
}
