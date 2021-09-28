#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param data_anr
#' @return
#' @author hlageek
#' @export
export_text_anr <- function(data_anr_sel,
                            anr_lang_desc) {

    keepers <- anr_lang_desc %>% 
        filter(resume_lang == "fra") %>% 
        pull(code_du_projet)
        
    texts <- data_anr_sel %>% 
        select(code_du_projet,
               titre,
               resume) %>% 
        filter(code_du_projet %in% keepers) %>% 
        mutate(text = paste(titre, resume),
               titre = NULL,
               resume = NULL) %>% 
        mutate(text = tolower(text)) %>% 
        mutate(text = str_replace_all(text, "[[:punct:]]", " ")) %>% 
        mutate(text = str_replace_all(text, "\\s{2,}", ""))
    
    file <- here::here("data", "data_derived", "corpus_anr.tsv")
    
    readr::write_tsv(texts, 
                     file)
    
    return(file)
    

}
