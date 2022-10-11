
list(
    
    # Establish data board
    tar_target(agency_data_board,
                pins::board_url(c(
                    data_csf = 
                        get_pins_url(token = "AgsdIbheNFjtq4J"),
                    data_anr = 
                        get_pins_url(token = "XK2fMdo1eN1qYxt"),
                    data_erc = 
                        get_pins_url(token = "5LiU3bWv1X4Mu1i")
                    ))
               ),
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


