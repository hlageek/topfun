#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param data_csf
#' @return
#' @author hlageek
#' @export
filter_csf <- function(csf_data_raw, years) {

    csf_data_prefiltered <- csf_data_raw |>
    filter(str_detect(project_id, "GA|GJ")) |> 
    filter(str_count(abstract) > 100) 

   whitelisted  <-  c("eng", "ces")

   csf_data_filtered <- csf_data_prefiltered |> 
    mutate(
        lang_abs = purrr::map_chr(abstract, ~franc::franc(.x, whitelist = whitelisted, min_speakers = 0)),
        lang_title = purrr::map_chr(title, ~franc::franc(.x, whitelist = whitelisted, min_speakers = 0))
    )   |> 
    # csf_data_filtered |> summarize(mean(lang_abs == "eng"), .by = year) |> arrange(desc(year)) |> print(n=30)
    filter(lang_abs == "eng" & lang_title == "eng") |> 
    select(-lang_abs, -lang_title)


filter_by_years(csf_data_raw, years = years)

}
