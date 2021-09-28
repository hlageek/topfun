#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param data_anr_sel
#' @return
#' @author hlageek
#' @export
plot_data_all_type <- function(data_all) {

    data_all %>% 
        group_by(country, year) %>% 
        count(type) %>% 
        ggplot(aes(year, n, color = country)) +
        geom_line(aes(linetype = rev(type))) +
        scale_linetype_discrete(name = "funding scheme") +
        theme_minimal()
}
