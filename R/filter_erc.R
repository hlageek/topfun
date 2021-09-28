#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param data_erc
#' @return
#' @author hlageek
#' @export
filter_erc <- function(data_erc) {

    data_erc %>% 
        filter(str_detect(fundingScheme, "ERC-SG|ERC-CG|ERC-AG")) %>% 
        mutate(type = if_else(fundingScheme == "ERC-SG", 
               "ERC-Starting",
               "ERC-Consolidator/Advanced"),
               year = format(startDate, "%Y")
        )  %>% 
        mutate(code = as.character(rcn),
                year = as.integer(year)) %>% 
        filter(year < 2013) %>% 
        mutate(duration = as.integer(endDate-startDate)/365) 
        
               
               
               }
