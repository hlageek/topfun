test$data[[1]] |> 
    group_by(topic) |> 
    summarise(mean = mean(weight),
              median = median(weight)
    ) |> 
    filter(mean < 1.5*median)

library(tidyverse)
colnames(anr_2010_df)
colnames(anr_2010_partners_df)
nrow(anr_2010_df)
nrow(anr_2010_partners_df)

anr_2005_df
colnames(anr_2010_partners_df)

anr_2010_df |> inner_join(anr_2010_partners_df, by = "projet_code_decision_anr") |> View()

bind_rows(anr_2005_df, anr_2010_df) |> summary()

summary(anr_2010_df)


colnames(anr_2005_df)
colnames(anr_2005_partners_df)
nrow(anr_2005_df)
nrow(anr_2005_partners_df)

pins::board_folder(here::here("data", "data_raw"))

targets::tar_read(import_test4, store = "_data_import")
targets::tar_config_get("store")
targets::tar_destroy("all")
targets::tar_visnetwork()
targets::tar_manifest()
targets::tar_script(script = "_data_import.R")
tar_config_get("script")
targets::tar_destroy("all", store = "_targets")


library(httr)
library(jsonlite)

# Base URL for the NWOpen-API projects endpoint
base_url <- "https://nwopen-api.nwo.nl/NWOpen-API/api/Projects"

# Initialize variables for pagination
page <- 1
per_page <- 100 # Adjust per_page as needed within the API's allowed range
all_projects <- list()

# Function to fetch a single page of projects
get_projects_page <- function(page, per_page) {
  # Construct the API request URL with pagination parameters
  api_url <- paste0(base_url, "?page=", page, "&per_page=", per_page)
  
  # Make the GET request
  response <- GET(api_url)
  
  # Check if the request was successful and parse the JSON response
  if (http_status(response)$category == "success") {
    content <- content(response, as = "text")
    json_data <- fromJSON(content)
    return(json_data$projects)
  } else {
    warning("Failed to retrieve data from the API for page ", page)
    return(NULL)
  }
}

# Fetch all pages of projects
repeat {
  cat("Fetching page", page, "\n")
  projects_page <- get_projects_page(page, per_page)
  
  # If no projects are returned, we've reached the end
  if (is.null(projects_page) || length(projects_page) == 0) {
    break
  }
  
  # Append the current page of projects to the all_projects list
  all_projects <- c(all_projects, projects_page)
  
  # Increment the page number for the next request
  page <- page + 1
}

# Extract project IDs from all projects
project_ids <- sapply(all_projects, function(project) project$project_id)

# Print the list of project IDs
print(project_ids)
gepris_url <- "https://gepris.dfg.de/gepris/OCTOPUS?beginOfFunding=&bewilligungsStatus=&bundesland=DEU%23&context=projekt&einrichtungsart=-1&fachgebiet=%23&findButton=historyCall&gefoerdertIn=&ggsHunderter=0&hitsPerPage=50&index=1&nurProjekteMitAB=false&oldGgsHunderter=0&oldfachgebiet=%23&pemu=24&peu=%23&task=doKatalog&teilprojekte=true&zk_transferprojekt=false"

gepris_entrypage <- rvest::read_html(gepris_url)

max_page <- gepris_entrypage |>
  rvest::html_elements("div.pagination") |>
  rvest::html_text(trim = TRUE) |>
  stringr::str_extract("\\s\\d*$") |>
  trimws() |>
  as.integer()


subsequent_pages <- paste0(
  unlist(strsplit(gepris_url, "index=1"))[1],
  "index=",
  seq(50, 50 * max_page - 1, 50),
  unlist(strsplit(gepris_url, "index=1"))[2]
)

project_links <- purrr::map(tail(subsequent_pages), .f = function(x) {
  partial_link <- rvest::read_html(x) |>
    rvest::html_nodes("div.results") |>
    rvest::html_elements("h2") |>
    rvest::html_nodes("a") |>
    rvest::html_attr("href")

  paste0("https://gepris.dfg.de", partial_link, "?language=en")
})


res_df <- purrr::map_df(unlist(project_links), .f = function(x) {
  record_page <- rvest::read_html(x)

  res <- tibble::tibble(
    project_url = x,
    title = record_page |>
      rvest::html_node("div.details") |>
      rvest::html_node("h1.facelift") |>
      rvest::html_text(trim = TRUE),
    applicant = record_page |>
      rvest::html_node("div.details") |>
      rvest::html_node("a.intern") |>
      rvest::html_text(trim = TRUE),
    applicant_url = record_page |>
      rvest::html_node("div.details") |>
      rvest::html_node("a.intern") |>
      rvest::html_attr("href"),
    subject_area = record_page |>
      rvest::html_node("div.details") |>
      rvest::html_node("div.firstUnderAntragsbeteiligte") |>
      rvest::html_node(".value") |>
      rvest::html_text(trim = TRUE),
    term = record_page |>
      rvest::html_node("div.details") |>
      rvest::html_node("div.firstUnderAntragsbeteiligte") |>
      rvest::html_element(xpath = "//div[span[contains(., 'Term')]]/span[@class='value']") |>
      rvest::html_text(trim = TRUE),
    abstract = record_page |>
      rvest::html_node("#projektbeschreibung") |>
      rvest::html_node("#projekttext") |>
      rvest::html_text(trim = TRUE),
    program = record_page |>
      rvest::html_node("#projektbeschreibung") |>
      rvest::html_node(".value") |>
      rvest::html_text(trim = TRUE)
  )
  Sys.sleep(0.2)

  return(res)
})

scrape_dfg(
      gepris_url = "https://gepris.dfg.de/gepris/OCTOPUS?beginOfFunding=&bewilligungsStatus=&bundesland=DEU%23&context=projekt&einrichtungsart=-1&fachgebiet=%23&findButton=historyCall&gefoerdertIn=&ggsHunderter=0&hitsPerPage=50&index=1&nurProjekteMitAB=false&oldGgsHunderter=0&oldfachgebiet=%23&pemu=24&peu=%23&task=doKatalog&teilprojekte=true&zk_transferprojekt=false",
      outfile = here::here("data", "data_raw", "dfg.tsv"), 
      run = TRUE
      )

---
title: "TOPFUN targets pipeline"
format:
  html:
    toc: true
---


### Import of raw data 

This section loads the raw data from the `_pinboard` subproject.

```{r, engine='targets', label='data_import'}
list(
  # Download CSF dataset
  tar_target(
    name = data_csf,
    command = qs::qread(data_files$data_csf_df_file$path),
    format = "feather"
  ),

  # Download ANR dataset
  tar_target(
    name = data_anr,
    command = qs::qread(data_files$data_anr_df_file$path),
    format = "feather"
  ),

  # Download CORDIS dataset
  tar_target(
    name = data_erc,
    command = qs::qread(data_files$data_erc_df_file$path),
    format = "feather"
  )
)
```



## Language detection

Here we ensure that the text data - project abstracts - that we work with are either in English or in French. Automatic language detection is used for this purpose. In addition, French data are automatically translated into English. 


```{r, engine='targets', label='lang'}
# list(
    
#     tar_target(anr_lang_desc,
#                InputData(data = data_anr,
#                            id = "code_du_projet",
#                            col = "resume",
#                            whitelist = c("fra", "eng"),
#                            keep_all = FALSE
#                            )
#                ),
    
#     tar_target(csf_lang_desc,
#                detect_lang(data = data_csf,
#                            id = "project_code",
#                            col = "abstract",
#                            whitelist = c("ces", "eng"),
#                            keep_all = FALSE
#                            )
#     ),
    
#     tar_target(data_anr_for_translation,
#         data_anr |> 
#             filter(code_du_projet %in% 
#                               (anr_lang_desc |> 
#                               filter(resume_lang == "fra") |> 
#                               pull(code_du_projet))
#                           ) |> 
#             mutate(source_text = 
#                        paste(titre,
#                              resume, 
#                              sep = ". "
#                              )
#                    ) |> 
#             select(code_du_projet,
#                    source_text
#                    )
#                ),
    
#     tar_target(data_anr_translated,
#                run_cubbitt_api(
#                    data_anr_for_translation |> 
#                        slice_head(n = 5),# test on sample
#                    col = "source_text",
#                    new_col = "resume_tr"),
#                cue = tar_cue("never")
#                )
    
    
# )

```



## Comparative dataset - descriptive plots

From the full datasets, we select only the projects that can be meaningfully compared across different (inter)national contexts. The criteria are:

- overlap in time
- overlap in the type of projects
    - i.e. we select only only investigator-initiated projects and distinguish junior and advanced schemes.
    
A single, unified dataset for comparison is produced.
    
Basic descriptive statistics are calculated and plotted.

```{r, engine='targets', label='compare'}

# list(
    
#     tar_target(data_anr_sel,
#                filter_anr(data_anr)
#                ),
    
#     tar_target(data_csf_sel,
#                filter_csf(data_csf)
#                ),
    
#     tar_target(data_erc_sel,
#                filter_erc(data_erc)
#                ),
    
#     tar_target(data_all,
#                combine_anr_csf(data_anr_sel,
#                                data_csf_sel,
#                                data_erc_sel)),
#     # number of projects
#     tar_target(data_all_type_plot,
#                plot_data_all_type(data_all)),
#     # funding amounts - absolute
#     tar_target(data_all_funding_plot,
#                plot_data_all_funding(data_all)),
#     # funding amounts - normalized by number of projects
#     tar_target(data_all_mean_plot,
#                plot_data_all_mean(data_all)),
#     # funding amounts - normalized by number of projects and their duration in years
#     tar_target(data_all_mean_yearlyplot,
#                plot_data_all_mean_yearly(data_all))
    
    
    
    
# )
```

## Text data for export

This section prepares text data to be exported as inputs for topic modeling. It uses only the projects that were selected for the comparative dataset.

```{r, engine='targets', label='text_export'}

# list(
    
    
#     tar_target(text_export_anr,
#                export_text_anr(data_anr_sel,
#                                anr_lang_desc),
#                format = "file"),
    
#     tar_target(text_export_csf,
#                export_text_csf(data_csf_sel,
#                                csf_lang_desc),
#                format = "file"),
    
#     tar_target(text_export_erc,
#                export_text_erc(data_erc_sel),
#                format = "file")
    
    
    
# )

```

## Load topic models

The following section contains topic models that were calculated on the basis of text exported in the text export section.

```{r, engine='targets', label='topic_models_pins'}

# list(
    
 
#     tar_target(topic_models_files,
#                suppressMessages( topic_models_board |> 
#                                      pin_download("topic_models")
#                                  )
#                )
    
    
# )

```

```{r, engine='targets', label='topic_models'}
# list(# ANR
#    tar_target(topic_model_anr,
#               qs::qread(str_subset(topic_models_files, "topic_model_202109292040.qs"))
#     ),
    
#     # CSF
#     tar_target(topic_model_csf,
#               qs::qread(str_subset(topic_models_files, "topic_model_202109300955.qs"))
#     ),
#     # ERC
#    tar_target(topic_model_erc,
#               qs::qread(str_subset(topic_models_files, "topic_model_202109301159.qs"))
#     )
# )
```

```{r, engine='targets', label='topic_models_combined'}
# list(
#   tar_target(topic_models_words, 
#              combine_topic_models(models = list("anr" = topic_model_anr,
#                                                 "erc" = topic_model_erc,
#                                                 "csf" = topic_model_csf
#                                              ),
#                                   dim = "word_topics")
#              ),
#     tar_target(topic_models_docs, 
#              combine_topic_models(models = list("anr" = topic_model_anr,
#                                                 "erc" = topic_model_erc,
#                                                 "csf" = topic_model_csf
#                                              ),
#                                   dim = "doc_topics") |> 
#                  pivot_longer(cols = starts_with("topic"),
#                               names_to = "topic",
#                               values_to = "weight",
#                               values_drop_na = TRUE)
#              )
# )

```


## Plot topic models

```{r, engine='targets'}
#| label: plot_topic_models

# list(
#     tar_target(topics_csf_plot_level_1,
#                plot_topics(topic_model_csf, level = 1L),
#                format = "qs"),
#         tar_target(topics_erc_plot_level_1,
#                plot_topics(topic_model_erc, level = 1L),
#                format = "qs"),
#         tar_target(topics_anr_plot_level_1,
#                plot_topics(topic_model_anr, level = 1L),
#                format = "qs")
# )

```

## Plot topic distributions

```{r, engine='targets', label='topic_distribution_plots'}
#| label: plot_topic_distributions

#  list(
              

#     tar_target(topic_distribution_plots,
#                plot_topic_distributions(topic_models_docs, level = 1),
#                format = "qs")
    
# )

```

## Calculate statistics on topics

```{r, engine='targets'}
#| label: topic_stats

#  list(
              

#     tar_target(topics_diversity,
#                calc_topics_diversity(topic_models_docs, level = 1),
#                format = "qs"),
#     tar_target(topics_diversity_exp,
#                calc_topics_diversity_exp(topics_diversity, data_all),
#                format = "qs"),
#     tar_target(topics_diversity_plots,
#                plot_topics_diversity_exp(topics_diversity_exp)
#                )
    
    
# )

```

## Data overview report

This section produces an initial report on the available data with basic descriptive statistics.

```{r, engine='targets'}
#| label: data_overview

# list(
#     tarchetypes::tar_quarto(data_overview,
#                             here::here("Rmd/data_overview.qmd"),
#                             execute_params = list(targets_store = "_targets"))
# )

```


# OpenAlex
library(openalexR)
options(openalexR.mailto = "hladik@flu.cas.cz")


  
  (recs <- oa_fetch(
  entity = "works",
  publication_year = 2020,
  language = "en",
  has_doi = TRUE,
  has_abstract = TRUE,
  type = c("article"),
  options = list(
   # sample = 10,
   # seed = 123,
    select = c("id"
    #, "publication_year", "display_name", "abstract_inverted_index", "type"
    )
    ),
  verbose = TRUE,
  abstract = TRUE,
  mailto = getOption("openalexR.mailto")
  )) |> View()


get_oa_recs_safely <- purrr::safely(get_oa_recs, quiet = F)

oa_df <- doi_df_nested  |> mutate(oa_table = purrr::map(data, .f = get_oa_recs_safely))

test <- readr::read_tsv(here::here("data", "data_raw", "dfg_projects.tsv"), col_names = FALSE)
names(test)
test2 <- test |> 
dplyr::filter(!duplicated(X1))

readr::write_delim(test2, file = here::here("data", "data_raw", "dfg_projects.tsv"), col_names = FALSE)

## TIER protocol 4.0 
    dir.create("data")  
    dir.create("Data/intermediate_data")  
    dir.create("Data/analysis_data")
    dir.create("Data/input_data")
    dir.create("Data/input_data/Metadata")
    dir.create("Data/input_data")

    dir.create("Output")
    dir.create("Output/DataAppendixOutput")
    dir.create("Output/Results")


    dir.create("scripts")
    dir.create("scripts/analysis_scripts")
    dir.create("scripts/DataAppendixscripts")
    dir.create("scripts/processing_scripts")
        dir.create("scripts/processing_scripts/DataCollectionscripts")

    

    dir.create("references")

osfr::osf_auth(Sys.getenv("OSF_PAT"))

topfun_project <- osfr::osf_retrieve_node("https://osf.io/gf4ch/")
osf_intermediate_data <- osfr::osf_ls_files(topfun_project, path = "data", pattern = "intermediate_data")
test_upload  <- osfr::osf_upload(osf_intermediate_data, path = here::here("data", "intermediate_data", "topfun_data_archive-20240206161536.zip"))

osfr::osf_download(test_upload, "~/Downloads")

osfr::osf_upload(osf_intermediate_data, path = here::here("data", "intermediate_data", "topfun_data_archive-20240206161536.zip"), conflicts = "overwrite")

colnames(anr_data_projects)
anr_data_projects |>  filter(stringr::str_detect(projet_code_decision_anr, "BLAN"))
anr_data_projects |> count(programme_acronyme, aap_edition) |> arrange(desc(n)) |> View()


anr_data_institutions |> 
filter(duplicated(project_id))

readr::read_csv2("~/Downloads/test.csv")


test <- bind_rows(
  erc_data, anr_data, dfg_data, snsf_data
)

test |> count(agency)

  key <- Sys.getenv("CEP_API")

call <- paste0("curl -X POST -F 'token=", key, "' -F 'rezim=filtr-seznam' -F 'oblast=cep' -F 'pr-kod-fix=GA103/06/0617' https://api.isvavai.cz/api.php")
      response <- system(call, intern = TRUE)
