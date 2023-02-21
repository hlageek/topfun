#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author hlageek
#' @export
call_hal <- function(type, year) {

hal_data <-  odyssey::hal_api()  |> 
   odyssey::hal_query("fr", field = "language_s") |>
   odyssey::hal_filter(year, field = "producedDateY_i") |> 
   odyssey::hal_filter('["" TO *]', field = "fr_abstract_s") |>
   odyssey::hal_filter(type, field = "docType_s") |> 
   odyssey::hal_select(
    c(
   "docid",
   "producedDate_s",
   "docType_s",
   "fr_title_s",
   "fr_subTitle_s",
   "fr_abstract_s",
   "fr_keyword_s",
   "domain_s",
   "discipline_s",
   "tematice_studyField_s",
   "authFullName_s",
   "anrProjectReference_s",
   "pubmedId_s",
   "wosId_s",
   "journalTitle_s",
   "journalIssn_s",
   "journalEissn_s",
   "isbn_s",
   "doiId_s",
   "halId_s",
   "funding_s"
   )) |> 
   odyssey::hal_search(limit = 10000)

}
