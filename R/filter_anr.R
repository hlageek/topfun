#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param data_anr
#' @return
#' @author hlageek
#' @export
filter_anr <- function(anr_data, years = NULL) {
  # selected_programs <- c(
  #     "AAPG2023",
  #     "AAPG2022",
  #     "AAPG2021",
  #     "AAPG2020",
  #     "AAPG2019",
  #     "AAPG2018",
  #     "AAPG2017",
  #     "AAPG2016",
  #     "AAPG2015",
  #     "Appel à projets générique",
  #     "Blanc 2013",
  #     "Blanc",
  #     "BLANC",
  #     "Blanc International I",
  #     "Blanc International II",
  #     "Blanc – Accords bilatéraux 2013",
  #     "Blanc international 2010",
  #     "JC",
  #     "JCJC"
  # )

  anr_string <- c("aapg", "générique", "blanc", "jc")

  anr_data_filtered <- anr_data |>
    filter(str_detect(tolower(program), paste0(anr_string, collapse = "|")))

 filter_by_years(anr_data_filtered, years)

}
