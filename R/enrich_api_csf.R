#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param csf_download_files
#' @param path
#' @return
#' @author hlageek
#' @export
enrich_api_csf <- function(csf_download_files, path, run = FALSE) {
  if(!isTRUE(run)) {
  warning_msg <- "The `run` argument is set to FALSE. Perhaps you do not have API_RUN set to TRUE in .Revinron?"
  warning(warning_msg)
  outfile <- NULL
} else {
  csf_data <- readr::read_csv(csf_download_files) |>
    dplyr::select(kod_projektu, poskytovatel, kod_programu)

  csf_gacr <- csf_data |>
    dplyr::filter(poskytovatel == "GA0" & kod_programu %in% c("GA", "GJ"))

  api_df <- csf_gacr |>
    dplyr::mutate(api_response = purrr::map(kod_projektu, ~ call_cep_safely(.x, Sys.getenv("CEP_API"))))

  enriched_df <- api_df |>
    dplyr::mutate(res = purrr::map(api_response, .f = function(x) {
      jsonlite::fromJSON(x[[1]][[1]])$data[c("jmeno", "prijmeni")]
    })) |>
    tidyr::unnest(res) |>
    dplyr::select(kod_projektu, jmeno, prijmeni)

  readr::write_csv(enriched_df, path)
  outfile <- path
}
return(outfile)
}

call_cep <- function(project_code, key) {
  call <- paste0("curl -X POST -F 'token=", key, "' -F 'rezim=filtr-seznam' -F 'oblast=cep' -F 'pr-kod-fix=", project_code, "' https://api.isvavai.cz/api.php")
  response <- system(call, intern = TRUE)
  Sys.sleep(0.05)
  response
}
call_cep_safely <- purrr::safely(call_cep, otherwise = NA)
