#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param base_url
#' @param mid_url
#' @param token
#' @param ext
#' @return
#' @author hlageek
#' @export
get_pins_url <- function(base_url = "https://owncloud.cesnet.cz",
                         mid_url = "remote.php/dav/public-files", 
                         token = NULL,
                         pattern = "data.txt") {

    stopifnot("Url portions must be without slash at the end." = 
                  !stringr::str_detect(base_url, "\\/$") |
                  !stringr::str_detect(mid_url, "\\/$"))

    pins_url <- httr::VERB(
        verb = "PROPFIND",
        url = paste0(base_url, "/", mid_url, "/", token),
        httr::add_headers(depth = 3),
        httr::authenticate(token, "") 
        ) |>  
        httr::content() |> 
        xml2::xml_find_all(".//d:href") |> 
        xml2::xml_text() |>  
        stringr::str_subset(pattern) |>  
        stringr::str_replace(pattern, "") 
        
    
    paste0(base_url, pins_url)


}
