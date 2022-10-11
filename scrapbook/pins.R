library(tidyverse)

topfun_board <- pins::board_folder("~/ownCloud/boards/topfun", versioned = FALSE)

# CSF
data_csf_df <- readr::read_tsv("https://owncloud.cesnet.cz/index.php/s/HIm7FEYQIMfoBuu/download")
data_csf_df_file <- paste0(tempfile(), ".qs")
qs::qsave(data_csf_df, data_csf_df_file)
pins::pin_upload(board = topfun_board, 
                 paths = data_csf_df_file, 
                 name = "data_csf_df_file", 
                 title = "Czech Science Foundation Dataset",
                 description = "A dataset of CSF funded projects obtained from the CEP database.",
                 metadata = list("license" = "None"), versioned = FALSE)



# ANR
data_anr_df <- readr::read_delim("https://data.enseignementsup-recherche.gouv.fr//explore/dataset/fr-esr-aap-anr-projets-retenus-participants-identifies/download",
                                 delim = ";",
                                 locale = locale("fr",
                                                 decimal_mark = "."))
data_anr_df_file <- paste0(tempfile(), ".qs")
qs::qsave(data_anr_df, data_anr_df_file)
pins::pin_upload(board = topfun_board, 
                 paths = data_anr_df_file, 
                 name = "data_anr_df_file", 
                 title = "Agence nationale de la recherche Dataset",
                 description = "A dataset of ANR funded projects obtained from https://data.enseignementsup-recherche.gouv.fr/explore/dataset/fr-esr-aap-anr-projets-retenus-participants-identifies/information/?disjunctive.identifiant_de_partenaire.",
                 metadata = list("license" = "Ouvert"), versioned = FALSE)

# ERC
data_erc_df <- readr::read_csv2("https://owncloud.cesnet.cz/index.php/s/wYTYM2o5Tj1xr8j/download")
data_erc_df_file <- paste0(tempfile(), ".qs")
qs::qsave(data_erc_df, data_erc_df_file)
pins::pin_upload(board = topfun_board, 
                 paths = data_erc_df_file, 
                 name = "data_erc_df_file", 
                 title = "European Research Council Dataset",
                 description = "A dataset of ERC funded projects obtained from CORDIS database",
                 metadata = list("license" = "European Commission reuse notice"), versioned = FALSE)


# topic models
data_files <- list.files(here::here("~/ownCloud/repos_data/topfun/data/data_raw/"),
                         full.names = TRUE) %>% 
    stringr::str_subset("qs") 

pins::pin_upload(board = topfun_board, paths = data_files, name = "topic_models_per_agency", title = "Topic models of project abstracts per agency")

