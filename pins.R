library(tidyverse)

data_csf_df <- readr::read_tsv("https://owncloud.cesnet.cz/index.php/s/HIm7FEYQIMfoBuu/download")
data_anr_df <- readr::read_delim("https://data.enseignementsup-recherche.gouv.fr//explore/dataset/fr-esr-aap-anr-projets-retenus-participants-identifies/download",
                           delim = ";",
                           locale = locale("fr",
                                           decimal_mark = "."))
)
data_erc_df <- readr::read_csv2("https://owncloud.cesnet.cz/index.php/s/wYTYM2o5Tj1xr8j/download")


topfun_board <- pins::board_folder("~/ownCloud/boards/topfun", versioned = TRUE)

pins::pin_upload(topfun_board)

pins::pin_write(topfun_board,
                data_csf_df,
                "Czech Science Foundation Dataset",
                type = "arrow",
                description = "A dataset of CSF funded projects obtained from the CEP database.",
                metadata = list("license" = "None"))

pins_urls <- httr::VERB(
    verb = "PROPFIND",
    url = "https://owncloud.cesnet.cz/remote.php/dav/public-files/fBCogVlbJVV5yx2",
    httr::add_headers(depth = 3),
    httr::authenticate("fBCogVlbJVV5yx2", "") 
) %>% 
    httr::content() %>% 
    xml2::xml_find_all(".//d:href") %>% 
    xml2::xml_text() %>% 
    stringr::str_subset("data.txt") %>% 
    stringr::str_replace("data.txt", "") %>% 
    paste0("https://owncloud.cesnet.cz", .) %>% 
    set_names(as.character(seq_along(.)))

test_board <- board_url(c("1" = "https://owncloud.cesnet.cz/remote.php/dav/public-files/fBCogVlbJVV5yx2/Czech%20Science%20Foundation%20Dataset/20220729T094915Z-17f8f/"))

test_board %>% pins::pin_info()

