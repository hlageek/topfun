
list(
    
    # Download CSF data
    
    # tar_cue(mode = "never") means the target runs only when the targets cache is empty
    # download_data() checks if file exists in the location and skips the download
    # if that is the case. This means that for a full refresh of the project,  
    # data should be manually removed from the raw_data folder and the target should be
    # invalidate with targets::tar_invalidate(data_csf_download)

    
    # Download CSF dataset
    tar_target(
        data_csf_download,
        download_data(
            url = "https://owncloud.cesnet.cz/index.php/s/HIm7FEYQIMfoBuu/download",
            data_file = here("data", 
                             "data_raw", 
                             "czech_science_foundation.tsv")
            ),
        format = "file",
        cue = tar_cue(mode = "never")
    ),
   

    # Read CSF data as an R object
    tar_target(
        data_csf,
        read_tsv(data_csf_download)
    ),
    
    # Download ANR dataset
    tar_target(
        data_anr_download,
        download_data(
            url = "https://data.enseignementsup-recherche.gouv.fr//explore/dataset/fr-esr-aap-anr-projets-retenus-participants-identifies/download",
            data_file = here("data", 
                             "data_raw", 
                             "agence_nationale_recherche.csv")
            ),
        format = "file",
        cue = tar_cue(mode = "never")
    ),
    
    # Read ANR data as an R object
    tar_target(
        data_anr,
        read_delim(data_anr_download,
                   delim = ";",
                   locale = locale("fr",
                                  decimal_mark = "."))
    ),
    
    # Download CORDIS dataset
    
    tar_target(
        data_erc_download,
        download_data(
            url = "https://cordis.europa.eu/data/cordis-fp7projects.csv",
        data_file = here("data", 
                             "data_raw", 
                             "cordis-fp7projects.csv")
        ),
        format = "file",
        cue = tar_cue(mode = "never")
        
    ),
    
    # Read ERC data as an R object
    tar_target(
        data_erc,
        read_csv2(data_erc_download)
    )
    
)


