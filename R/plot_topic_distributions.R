#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param topics
#' @param level
#' @return
#' @author hlageek
#' @export
plot_topic_distributions <- function(topics, level = 1) {

        topics %>%
            pluck("doc_topics") %>% 
            pluck(level) %>% 
            mutate(across(where(is.numeric), na_if, 0)) %>% 
            pivot_longer(cols = starts_with("topic"), 
                         names_to = "topic", 
                         values_to = "weight",
                         values_drop_na = TRUE) %>% 
            ggplot(aes(weight)) +
            geom_histogram() +
            facet_wrap(~topic, scales = "free")
        
}
