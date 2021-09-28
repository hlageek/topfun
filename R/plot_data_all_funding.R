#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param data_all
#' @return
#' @author hlageek
#' @export
plot_data_all_funding <- function(data_all) {

    data_all %>% 
        group_by(country, year, type) %>% 
        summarise(amount = sum(amount, na.rm = TRUE),
                  .groups = "drop") %>% 
        ggplot(aes(year, amount, color = country)) +
        geom_line(aes(linetype = rev(type))) +
        scale_linetype_discrete(name = "funding scheme") +
        scale_y_continuous(labels = scales::comma) +
        theme_minimal()

}
