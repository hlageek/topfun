
list(
    
    # ANR
    tar_target(topic_model_anr_data,
               download_data(
            url = "https://owncloud.cesnet.cz/index.php/s/riibpYmTDiYVHZO/download",
            data_file = here("data", 
                             "data_raw", 
                             "topic_model_202109292040.qs")
            ),
        format = "file",
        cue = tar_cue(mode = "never")
    ),
    
    tar_target(topic_model_anr,
               qread(topic_model_anr_data),
               format = "qs"),
    
    # CSF
    tar_target(topic_model_csf_data,
               download_data(
            url = "https://owncloud.cesnet.cz/index.php/s/a3ZqLZ2ljfJtoHo/download",
            data_file = here("data", 
                             "data_raw", 
                             "topic_model_202109300955.qs")
            ),
        format = "file",
        cue = tar_cue(mode = "never")
    ),
    
    tar_target(topic_model_csf,
               qread(topic_model_csf_data),
               format = "qs"),
    
    # ERC
    tar_target(topic_model_erc_data,
               download_data(
            url = "https://owncloud.cesnet.cz/index.php/s/WBMOFhftZDuWUhD/download",
            data_file = here("data", 
                             "data_raw", 
                             "topic_model_202109301159.qs")
            ),
        format = "file",
        cue = tar_cue(mode = "never")
    ),
    
    tar_target(topic_model_erc,
               qread(topic_model_erc_data),
               format = "qs")
    
)

