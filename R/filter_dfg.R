#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param dfg_data_raw
#' @param years
#' @return
#' @author hlageek
#' @export
filter_dfg <- function(dfg_data_raw, years = NULL) {

  
    dfg_data_prefiltered <- dfg_data_raw |>
    filter(str_detect(program, "^Research Grants$"))  |> 
    filter(str_count(abstract) > 100) 

   whitelisted  <-  c("eng", "deu")

   dfg_data_filtered <- dfg_data_prefiltered |> 
    mutate(
        lang_abs = purrr::map_chr(abstract, ~franc::franc(.x, whitelist = whitelisted, min_speakers = 0)),
        lang_title = purrr::map_chr(title, ~franc::franc(.x, whitelist = whitelisted, min_speakers = 0))
    )   |> 
    # dfg_data_filtered |> summarize(mean(lang_abs == "eng"), .by = year) |> arrange(desc(year)) |> print(n=30)
    filter(lang_abs == "eng" & lang_title == "eng") |> 
    select(-lang_abs, -lang_title)

filter_by_years(dfg_data_filtered, years = years)

}
