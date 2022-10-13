#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param topic_models_docs
#' @param level
#' @return
#' @author hlageek
#' @export
plot_topic_distributions <- function(topic_models_docs, level = 1) {

  plots <- topic_models_docs |> 
        filter(level == level) |> 
        select(agency, doc, topic, weight) |> 
        nest(data = c(doc, topic, weight)) |> 
        mutate(plots = map2(agency, data, function(agency, data) {
            
            data %>%
                ggplot(aes(weight)) +
                geom_histogram() +
                facet_wrap(~topic, scales = "free") +
                ggtitle(agency)
            
        }))

    plots$plots

        
}
