#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param data_csf
#' @return
#' @author hlageek
#' @export
filter_csf <- function(data_csf) {

    data_csf %>% 
        mutate(year_start) %>% 
        filter(year_start >= 2008 & year_start <= 2012) %>% 
        filter(program_code %in% c("GP", "GA", "GC", "GF", "GJ")) %>% 
        mutate(type = if_else(program_code == "GP", 
                              "Postdoc",
                              "Standard/International")) %>% 
        mutate(total = (total*1000)/25) %>% 
        mutate(duration = 1+year_end-year_start)

}
