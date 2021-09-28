#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param data_anr
#' @return
#' @author hlageek
#' @export
filter_anr <- function(data_anr) {

  data_anr %>% 
        mutate(year = as.integer(
            str_replace(code_du_projet, 
                        "ANR-(\\d{2}).*", 
                        "\\1")
            ),
            year = year + 2000L) %>% 
        mutate(program_title = 
                   str_replace(code_du_projet, 
                        "ANR-\\d{2}-([A-Z]{1,}).*", 
                        "\\1")
        ) %>% 
        mutate(programme = tolower(programme)) %>% 
        filter(str_detect(programme, "blanc|jcjc")) %>% 
        mutate(type = if_else(str_detect(programme, 
                                         "blanc"), 
                                         "BLANC",
                                         "JCJC")
               ) %>% 
        filter(year >= 2008 & year <= 2012) %>% 
    mutate(duration = duree_en_mois/12) 

}
