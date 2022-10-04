
list(
    
    tar_target(data_anr_sel,
               filter_anr(data_anr)
               ),
    
    tar_target(data_csf_sel,
               filter_csf(data_csf)
               ),
    
    tar_target(data_erc_sel,
               filter_erc(data_erc)
               ),
    
    tar_target(data_all,
               combine_anr_csf(data_anr_sel,
                               data_csf_sel,
                               data_erc_sel)),
    # number of projects
    tar_target(data_all_type_plot,
               plot_data_all_type(data_all)),
    # funding amounts - absolute
    tar_target(data_all_funding_plot,
               plot_data_all_funding(data_all)),
    # funding amounts - normalized by number of projects
    tar_target(data_all_mean_plot,
               plot_data_all_mean(data_all)),
    # funding amounts - normalized by number of projects and their duration in years
    tar_target(data_all_mean_yearlyplot,
               plot_data_all_mean_yearly(data_all))
    
    
    
    
)
