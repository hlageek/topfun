plot_topics <- function(data_df, level = 1) {
  top5words <- data_df %>%
      pluck("word_topics") %>% 
      pluck(level) %>% 
        group_by(topic) %>%
        slice_max(weight, n = 5) %>%
        ungroup()


  top5words %>%
        ggplot(aes(reorder(term, weight), weight)) +
        geom_col() +
        coord_flip() +
        facet_wrap(~topic, scales = "free")
    
}
