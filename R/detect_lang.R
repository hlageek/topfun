detect_lang <- function(data, id, col, whitelist, keep_all = TRUE) {

new_col <- paste0(col, "_lang")
    
data_na <- data %>% 
    filter(is.na(.data[[col]]))

data_detected <- data %>% 
    filter(!is.na(.data[[col]])) %>% 
    mutate(!!quo_name(new_col) := 
               purrr::map_chr(.data[[col]], 
                              ~franc::franc(.x, 
                                            whitelist = whitelist)))

result <- bind_rows(data_detected,
          data_na) 

if (!keep_all) {
    
    result <- result[, colnames(result) %in% c(id, col, new_col)]
    
}

}