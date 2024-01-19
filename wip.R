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
