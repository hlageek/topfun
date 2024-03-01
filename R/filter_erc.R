#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param erc_data_raw
#' @param years
#' @return
#' @author hlageek
#' @export
filter_erc <- function(erc_data_raw, years = NULL) {
  erc_data_filtered <- erc_data_raw |>
    filter(str_detect(program, "STG|COG|ADG"))

filter_by_years(erc_data_filtered, years)

}
