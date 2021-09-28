run_cubbitt_api <- function(df, col, new_col, src="fr", tgt="en") {
    
call_api <- function(input_text) {
httr::POST(url = "https://lindat.mff.cuni.cz/services/translation/api/v2/languages", body = list(src="fr", tgt = "en", input_text = input_text)) 
}

parse_response <- function(res) {
httr::content(res, encoding = "utf-8", as = "parsed") %>% 
    paste(collapse = " ") %>% 
    stringr::str_remove_all("\\n")
}

translate <- function(x) {
    Sys.sleep(0.1)
    call_api(x) %>% parse_response()
   
}

tr_df <- df %>% 
    mutate(!!quo_name(new_col) := purrr::map_chr(.data[[col]],
                                          ~translate(.x)))

}
    