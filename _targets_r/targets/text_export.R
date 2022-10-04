
list(
    
    
    tar_target(text_export_anr,
               export_text_anr(data_anr_sel,
                               anr_lang_desc),
               format = "file"),
    
    tar_target(text_export_csf,
               export_text_csf(data_csf_sel,
                               csf_lang_desc),
               format = "file"),
    
    tar_target(text_export_erc,
               export_text_erc(data_erc_sel),
               format = "file")
    
    
    
)

