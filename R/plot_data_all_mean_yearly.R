#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param data_all
#' @return
#' @author hlageek
#' @export
plot_data_all_mean_yearly <- function(data_all) {

    data_all %>% 
        filter(!is.na(duration)) %>% 
        group_by(country, year, type) %>% 
        summarise(amount_per_year = mean(amount/duration, na.rm = TRUE),
                  .groups = "drop") %>% 
        ggplot(aes(year, amount_per_year, color = country)) +
        geom_line(aes(linetype = rev(type))) +
        scale_linetype_discrete(name = "funding scheme") +
        scale_y_continuous(labels = scales::comma) +
        theme_minimal()
}
