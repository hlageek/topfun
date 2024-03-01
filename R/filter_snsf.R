#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param snsf_data_raw
#' @param years
#' @return
#' @author hlageek
#' @export
filter_snsf <- function(snsf_data_raw, years = NULL) {

    snsf_data_prefiltered <- snsf_data_raw |>
    filter(str_detect(program, "^Project funding$")) |> 
    filter(!is.na(abstract)) 

whitelisted  <-  c("eng", "deu", "fra", "roh", "ita")

   snsf_data_filtered <- snsf_data_prefiltered |> 
    mutate(
        lang_abs = purrr::map_chr(abstract, ~franc::franc(.x, whitelist = whitelisted, min_speakers = 0)),
        lang_title = purrr::map_chr(title, ~franc::franc(.x, whitelist = whitelisted, min_speakers = 0))
    )   |> 
    filter(lang_abs == "eng" & lang_title == "eng") |> 
    select(-lang_abs, -lang_title)

filter_by_years(snsf_data_filtered, years = years)

}
