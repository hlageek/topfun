#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param pinboard
#' @return
#' @author hlageek
#' @export
read_corpus <- function(pins) {

raw_preprocess <- function(x) {
  x |> 
# lowercase for text
mutate(text = tolower(text)) |> 
mutate(text = str_replace_all(text, "\\b\\w+[-]{1,}\\w+\\b", "_")) |> 
mutate(text = str_replace_all(text, "[^[:alnum:]]", " ")) |> 
mutate(text = str_squish(text))
}

check_lang <- function(x, pair, keep = "eng") {
  x |> 
  mutate(lang = purrr::map_chr(text, ~franc::franc(.x, whitelist = pair))) |> 
  filter( lang == keep) |> 
  select(-lang)

}

csf_data <- qs::qread(pins$data_csf_df_file$path) |> 
select(project_code, title = title_eng, abstract, keywords) |> 
# handle problematic values
# remove keyword separator
mutate(keywords = str_replace_all(keywords, "\\|", " ")) |>
# remove problematic keywords
mutate(keywords = if_else(str_length(keywords) < 12, "", keywords, "")) |> 
# remove problematic titles
mutate(title = if_else(str_length(title) < 5, "", title, ""))

csf_data_long <- csf_data |> 
pivot_longer(cols = -project_code, names_to = "type", values_to = "text") |> 
raw_preprocess() |> 
check_lang(pair = c("ces", "eng"))





}
