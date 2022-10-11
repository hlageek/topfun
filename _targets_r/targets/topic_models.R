
list(
    
        # Establish data board
    tar_target(topic_models_board,
                pins::board_url(c(
                    topic_models = 
                        get_pins_url(token = "w34U5qzjpRSCpev"))
                    )
               ),
    tar_target(topic_models_files,
               suppressMessages( topic_models_board %>% 
                                     pin_download("topic_models")
                                 )
               ),
    # ANR
    tar_target(topic_model_anr,
              qs::qread(str_subset(topic_models_files, "topic_model_202109292040.qs"))
    ),
    
    # CSF
    tar_target(topic_model_csf,
              qs::qread(str_subset(topic_models_files, "topic_model_202109300955.qs"))
    ),
    # ERC
    tar_target(topic_model_erc,
              qs::qread(str_subset(topic_models_files, "topic_model_202109301159.qs"))
    )
    
)

