#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param csf_data_raw
#' @param anr_data_raw
#' @param snsf_data_raw
#' @param dfg_data_raw
#' @return
#' @author hlageek
#' @export
archive_topfun_data <- function(data_files, archive_file) {
  
  utils::zip(
    zipfile = archive_file,
    files = unlist(data_files),
    extras = "--junk-paths"
  )
archive_file
}
