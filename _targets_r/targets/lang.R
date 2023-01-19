list(
    
    tar_target(anr_lang_desc,
               detect_lang(data = data_anr,
                           id = "code_du_projet",
                           col = "resume",
                           whitelist = c("fra", "eng"),
                           keep_all = FALSE
                           )
               ),
    
    tar_target(csf_lang_desc,
               detect_lang(data = data_csf,
                           id = "project_code",
                           col = "abstract",
                           whitelist = c("ces", "eng"),
                           keep_all = FALSE
                           )
    ),
    
    tar_target(data_anr_for_translation,
        data_anr |> 
            filter(code_du_projet %in% 
                              (anr_lang_desc |> 
                              filter(resume_lang == "fra") |> 
                              pull(code_du_projet))
                          ) |> 
            mutate(source_text = 
                       paste(titre,
                             resume, 
                             sep = ". "
                             )
                   ) |> 
            select(code_du_projet,
                   source_text
                   )
               ),
    
    tar_target(data_anr_translated,
               run_cubbitt_api(
                   data_anr_for_translation |> 
                       slice_head(n = 5),# test on sample
                   col = "source_text",
                   new_col = "resume_tr"),
               cue = tar_cue("never")
               )
    
    
)

