
list(
    # Download CSF dataset
    tar_target(data_csf,
               agency_data_board %>% 
                   pins::pin_download("data_csf") %>% 
                   qs::qread()
    ),
    
    # Download ANR dataset
    tar_target(data_anr,
               agency_data_board %>% 
                   pins::pin_download("data_anr") %>% 
                   qs::qread()
    ),
   
    # Download CORDIS dataset
        tar_target(data_erc,
               agency_data_board %>% 
                   pins::pin_download("data_erc") %>% 
                   qs::qread()
    )

    
)


