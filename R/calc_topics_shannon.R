compute_diversity <- function(freq, which = c("Shannon")){
    if(which == "Shannon"){
        index <- prod(freq^freq)^-1
    }
    if(which == "Herfindhal"){
        index <- sum(freq^2)
    }
    return(index)
}

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
calc_topics_diversity <- function(topic_models_docs, level = 1) {

    hierarchy <- level
    
    topic_models_docs |> 
        dplyr::filter(level == hierarchy) |> 
        group_by(agency, doc) |> 
        summarise(hhi = compute_diversity(weight, which = "Herfindhal"),
                  .groups = "drop") 
    

}


#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param topics_diversity
#' @param data_all
#' @return
#' @author hlageek
#' @export
calc_topics_diversity_exp <- function(topics_diversity, data_all) {
    
    exp_input <- topics_diversity |> 
        inner_join(data_all |> 
                      select(code, year, type), by = c("doc"="code"))
    diversity_exp <- list()
    
    diversity_exp$agency <- exp_input |> 
        group_by(agency) |> 
        summarise(mean = mean(hhi),
               sd = sd(hhi),
                  top_sd = mean+(2*sd),
                    bot_sd = mean-(2*sd),
               .groups = "drop")
    
    diversity_exp$agency_type <- exp_input |> 
        group_by(agency, type) |> 
        summarise(mean = mean(hhi),
                  sd = sd(hhi),
                  top_sd = mean+(2*sd),
                  bot_sd = mean-(2*sd),
                  .groups = "drop")
    
    diversity_exp$agency_year <- exp_input |> 
        group_by(agency, year) |> 
        summarise(mean = mean(hhi),
                  sd = sd(hhi),
                  top_sd = mean+(2*sd),
                  bot_sd = mean-(2*sd),
                  .groups = "drop")
    
    return(diversity_exp)
    
}



#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param topics_diversity_exp
#' @return
#' @author hlageek
#' @export
plot_topics_diversity_exp <- function(topics_diversity_exp) {
    
    diversity_plots <- list()
    
    diversity_plots$agency <- topics_diversity_exp$agency |> 
        ggplot(aes(agency, mean, col = agency)) +
        geom_point() +
        geom_errorbar(aes(ymin=bot_sd, ymax=top_sd), width=.2,
                      position=position_dodge(.9)) 
    
    diversity_plots$agency_type <- 
    topics_diversity_exp$agency_type |> 
        ggplot(aes(agency, mean, col = agency, group = type)) +
        geom_point(aes(shape = type), position = position_dodge((.9))) +
        geom_errorbar(aes(ymin=bot_sd, ymax=top_sd), width=.2,
                      position=position_dodge(.9)) 
    
    diversity_plots$agency_year <- 
    topics_diversity_exp$agency_year |> 
        ggplot(aes(year, mean, col = agency, group = agency)) +
        geom_line(aes(group = agency)) 
    
    return(diversity_plots)
    
}