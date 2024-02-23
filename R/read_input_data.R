#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title read_input_anr
#' @param input_data_files
#' @param file_name
#' @return
#' @author hlageek
#' @export
read_input_anr <- function(input_data_files, file_name) {
  path_to_file <- input_data_files[basename(input_data_files) %in% file_name]
  readr::read_delim(
    path_to_file,
    delim = ";",
    locale = readr::locale("fr", decimal_mark = "."),
    show_col_types = FALSE
  ) |>
    janitor::clean_names() |>
    dplyr::mutate(source = basename(path_to_file))
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#'
#' @title read_input_eu
#' @param input_data_files
#' @param file_name
#' @return
#' @author hlageek
#' @export
read_input_eu <- function(input_data_files, file_name) {
  path_to_file <- input_data_files[basename(input_data_files) %in% file_name]
  purrr::map_df(path_to_file, .f = function(x) {
    readr::read_csv2(x) |>
      janitor::clean_names() |>
      dplyr::mutate(source = basename(x))
  })
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#'
#' @title read_input_snsf
#' @param input_data_files
#' @param file_name
#' @return
#' @author hlageek
#' @export
read_input_snsf <- function(input_data_files, file_name) {
  path_to_file <- input_data_files[basename(input_data_files) %in% file_name]
  readr::read_csv2(path_to_file) |>
    janitor::clean_names() |>
    dplyr::mutate(source = basename(path_to_file))
}
