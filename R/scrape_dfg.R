#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param url
#' @param outfile
#' @return
#' @author hlageek
#' @export
scrape_dfg_catalogue <- function(gepris_url = NULL,
                       outfile = NULL, 
                       run = FALSE,
                       sleep_time = 5) {

if(!isTRUE(run)) {
  warning_msg <- "The `run` argument is set to FALSE. Perhaps you do not have API_RUN set to TRUE in .Revinron?"
  hal_data <- warning_msg
  warning(warning_msg)
  outfile <- NULL
} else {
  
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
  seq(50, 50 *( max_page-1), 50),
  unlist(strsplit(gepris_url, "index=1"))[2]
)

purrr::walk(c(gepris_url, subsequent_pages), .f = function(x) {

   Sys.sleep(sleep_time)

  partial_link <- rvest::read_html(x) |>
    rvest::html_nodes("div.results") |>
    rvest::html_elements("h2") |>
    rvest::html_nodes("a") |>
    rvest::html_attr("href")

  readr::write_lines(partial_link, outfile, append = TRUE)
})
}
outfile

}

scrape_dfg_projects <- function(gepris_catalogue = NULL,
                       outfile = NULL, 
                       run = FALSE,
                       sleep_time = 5) {

if (is.null(gepris_catalogue) | length(gepris_catalogue) == 0) {
  gepris_catalogue <- here::here("data", "data_raw", "dfg_catalogue.tsv")
}

if(!isTRUE(run)) {
  warning_msg <- "The `run` argument is set to FALSE. Perhaps you do not have API_RUN set to TRUE in .Revinron?"
  hal_data <- warning_msg
  warning(warning_msg)
  outfile <- NULL
} else {

gepris_links <- readLines(gepris_catalogue)

if (file.exists(here::here(outfile))) {

scraped_links <- readr::read_tsv(outfile, col_names = "links", show_col_types = F, col_select = 1) |> dplyr::pull(1)
scraped_links_match <- gsub("^https://gepris.dfg.de", "", scraped_links)
gepris_links <- gepris_links[!gepris_links %in% scraped_links_match]
}



 purrr::walk2(gepris_links, outfile, .f = function(url, outfile) {

  
    full_url <- paste0("https://gepris.dfg.de", url, "?language=en")

  record_page <- rvest::read_html(full_url)

  res <- tibble::tibble(
    project_url = paste0("https://gepris.dfg.de", url),
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

  res_clean <- res |> 
  dplyr::mutate(dplyr::across(everything(), ~stringr::str_replace_all(.x, "\\s{2,}", " "))) |> 
    dplyr::mutate(dplyr::across(everything(), ~stringr::str_replace_all(.x, "[\\n\\r]", " ")))

    readr::write_tsv(res_clean, outfile, append = TRUE)
    

  Sys.sleep(sleep_time)


})
}
  return(outfile)
                       
}
