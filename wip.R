test$data[[1]] |> 
    group_by(topic) |> 
    summarise(mean = mean(weight),
              median = median(weight)
    ) |> 
    filter(mean < 1.5*median)

library(tidyverse)
colnames(anr_2010_df)
colnames(anr_2010_partners_df)
nrow(anr_2010_df)
nrow(anr_2010_partners_df)

anr_2005_df
colnames(anr_2010_partners_df)

anr_2010_df |> inner_join(anr_2010_partners_df, by = "projet_code_decision_anr") |> View()

bind_rows(anr_2005_df, anr_2010_df) |> summary()

summary(anr_2010_df)


colnames(anr_2005_df)
colnames(anr_2005_partners_df)
nrow(anr_2005_df)
nrow(anr_2005_partners_df)
