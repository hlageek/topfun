topic_model_anr$doc_topics[[1]] %>% 
    pivot_longer(starts_with("topic"),
                 values_to = "weight",
                 names_to = "topic") %>% 
    filter(weight>0) %>% 
    group_by(doc) %>% 
    arrange(doc, desc(weight)) %>% 
    ungroup() %>% 
    inner_join(
        
        topic_model_anr$word_topics[[1]] %>% 
            group_by(topic) %>% 
            slice_max(weight, n = 10) %>% 
            mutate(topic_desc = paste(term, collapse = " ")) %>% 
            select(-term, -weight)
    ) %>% 
    
    inner_join(
        
        data_anr_sel %>% 
            select(titre, doc = code_du_projet)
    ) %>% 
    distinct() %>% View()


topic_model_anr$doc_topics[[1]] %>% 
    pivot_longer(starts_with("topic"),
                 values_to = "weight",
                 names_to = "topic") %>% 
    group_by(doc) %>% 
    arrange(doc, desc(weight)) %>% 
    ungroup() %>% 
    ggplot(aes(weight)) +
    geom_histogram() +
    facet_wrap(~topic)

test_norm <- function(x) {
    broom::tidy(shapiro.test(x)) %>% pull(p.value)
}

topic_model_anr$doc_topics[[1]] %>% 
    pivot_longer(starts_with("topic"),
                 values_to = "weight",
                 names_to = "topic") %>% 
    # filter(weight>0) %>% 
    group_by(topic) %>% 
    summarise(norm_test = test_norm(sample(weight, 30))) %>% 
    filter(norm_test>0.05) %>% 
    arrange(desc(norm_test))
    
    
