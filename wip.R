test$data[[1]] |> 
    group_by(topic) |> 
    summarise(mean = mean(weight),
              median = median(weight)
    ) |> 
    filter(mean < 1.5*median)