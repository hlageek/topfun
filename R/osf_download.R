#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param osf_url
#' @return
#' @author hlageek
#' @export
osf_download <- function(osf_url = NULL, osf_folder = "input_data", local_folder = NULL) {

osfr::osf_auth(Sys.getenv("OSF_PAT"))

osf_project <- osfr::osf_retrieve_node(osf_url)
osf_files <- osfr::osf_ls_files(osf_project, path = osf_folder)
local_files <- osfr::osf_download(osf_files, local_folder, conflict = "skip")

here::here(local_files$local_path)

}
