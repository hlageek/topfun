#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param eu_download_files
#' @return
#' @author hlageek
#' @export
unzip_eu_files <- function(eu_download_files) {
  csv_paths <- purrr::map(eu_download_files, .f = function(x) {
    unzipdir <- tempdir()
    unzip(x, files = "csv/project.csv", exdir = unzipdir)
    temp_loc <- list.files(paste0(unzipdir, .Platform$file.sep, "csv"), full.names = TRUE)[grepl("project", list.files(paste0(unzipdir, .Platform$file.sep, "csv")))]
    new_file <- here::here("data", "data_raw", gsub("zip", "csv", basename(x)))
    file.rename(temp_loc, new_file)
    new_file
  })
  unlist(csv_paths)
}
