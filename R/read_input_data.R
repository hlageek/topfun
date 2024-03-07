#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title read_input_anr
#' @param input_data_files
#' @param file_name
#' @return
#' @author hlageek
#' @export
read_input_anr <- function(input_data_files, file_name) {
  path_to_file <- input_data_files[basename(input_data_files) %in% file_name]
  raw_df <- readr::read_delim(
    path_to_file,
    delim = ";",
    locale = readr::locale("fr", decimal_mark = "."),
    show_col_types = FALSE
  ) |>
    janitor::clean_names() |>
    dplyr::mutate(source = basename(path_to_file))
  if (!"projet_partenaire_code_decision_anr" %in% colnames(raw_df)) {
    transmuted_df <- raw_df |>
      select(
        projet_code_decision_anr,
        programme_acronyme,
        aap_edition,
        projet_titre_anglais,
        projet_resume_anglais,
        projet_aide_allouee
      ) |>
      transmute(
        project_id = as.character(projet_code_decision_anr),
        program = as.character(programme_acronyme),
        year = as.integer(aap_edition),
        title = as.character(projet_titre_anglais),
        abstract = as.character(projet_resume_anglais),
        amount = as.integer(projet_aide_allouee),
        country = "FR",
        agency = "ANR"
      )
  } else {
    transmuted_df <- raw_df |>
      select(
        projet_code_decision_anr,
        projet_partenaire_est_coordinateur,
        projet_partenaire_responsable_scientifique_nom,
        projet_partenaire_responsable_scientifique_prenom
      ) |>
      transmute(
        project_id = as.character(projet_code_decision_anr),
        coordinator_lgl = as.logical(projet_partenaire_est_coordinateur),
        pi_name_last = as.character(projet_partenaire_responsable_scientifique_nom),
        pi_name_first = as.character(projet_partenaire_responsable_scientifique_prenom)
      ) |>
      filter(coordinator_lgl == TRUE) |>
      select(-coordinator_lgl)
  }
  transmuted_df |>
    finishing_touch()
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#'
#' @title read_input_eu
#' @param input_data_files
#' @param file_name
#' @return
#' @author hlageek
#' @export
read_input_eu <- function(input_data_files, file_name) {
  path_to_file <- input_data_files[basename(input_data_files) %in% file_name]
  raw_df <- purrr::map_df(path_to_file, .f = function(x) {
    readr::read_csv2(x) |>
      janitor::clean_names() |>
      dplyr::mutate(source = "ERC")
  })

  transmuted_df <- raw_df |>
    select(
      id,
      title,
      funding_scheme,
      ec_signature_date,
      title,
      objective,
      ec_max_contribution
    ) |>
    transmute(
      project_id = as.character(id),
      program = as.character(funding_scheme),
      year = as.integer(format(ec_signature_date, "%Y")),
      title = as.character(title),
      abstract = as.character(objective),
      amount = as.integer(ec_max_contribution),
      agency = "ERC"
    )

  transmuted_df |>
    finishing_touch()
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#'
#' @title read_input_erc
#' @param input_data_files
#' @param file_name
#' @return
#' @author hlageek
#' @export
read_input_erc <- function(input_data_files, file_name) {
  path_to_file <- input_data_files[basename(input_data_files) %in% file_name]
  raw_df <- readr::read_tsv(path_to_file) |>
    janitor::clean_names()
  transmuted_df <- raw_df |>
    select(
      project_number,
      call,
      project_title,
      abstract,
      researcher_s,
      eu_contribution,
      call_year,
      country
    ) |>
    transmute(
      project_id = as.character(project_number),
      program = as.character(call),
      year = as.integer(call_year),
      title = as.character(project_title),
      abstract = as.character(abstract),
      amount = as.integer(stringr::str_replace_all(eu_contribution, "[^0-9]", "")),
      pi_name_first = as.character(stringr::str_extract(researcher_s, "^\\b[A-Za-z-]+\\b")),
      pi_name_last = as.character(stringr::str_replace(researcher_s, "^\\b[A-Za-z-]+\\b(.*)", "\\1")),
      country = as.character(country),
      agency = "ERC"
    )
  transmuted_df |>
    finishing_touch()
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#'
#' @title read_input_snsf
#' @param input_data_files
#' @param file_name
#' @return
#' @author hlageek
#' @export
read_input_snsf <- function(input_data_files, file_name) {
  path_to_file <- input_data_files[basename(input_data_files) %in% file_name]
  raw_df <- readr::read_csv2(path_to_file) |>
    janitor::clean_names()

  transmuted_df <- raw_df |>
    select(
      grant_number_string,
      funding_instrument_published,
      title,
      title_english,
      abstract,
      responsible_applicant_name,
      amount_granted_all_sets,
      call_decision_year
    ) |> 
    transmute(
      project_id = as.character(grant_number_string),
      program = as.character(funding_instrument_published),
      year = as.integer(call_decision_year),
      title = as.character(ifelse(is.na(title_english), title, title_english)),
      abstract = as.character(abstract),
      amount = as.integer(stringr::str_replace_all(amount_granted_all_sets, "[^0-9]", "")),
      pi_name_first = as.character(stringr::str_extract(responsible_applicant_name, "(.*),[\\s*](\\b[^\\.\\s]{2,})\\b.*$", group = 2)),
      pi_name_last = as.character(stringr::str_replace(responsible_applicant_name, "(.*),[\\s*](\\b[^\\.\\s]{2,})\\b(.*)$", "\\1\\3")),
      country = "CH",
      agency = "SNSF"
    )
  transmuted_df |>
    finishing_touch()
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#'
#' @title read_input_dfg
#' @param input_data_files
#' @param file_name
#' @return
#' @author hlageek
#' @export
read_input_dfg <- function(input_data_files, file_name) {
  path_to_file <- input_data_files[basename(input_data_files) %in% file_name]
  raw_df <- readr::read_delim(path_to_file, col_names = c(
    "project_id",
    "title",
    "pi",
    "pi_url",
    "discipline",
    "years",
    "abstract",
    "program"
  )) |>
    janitor::clean_names() |> 
    filter(!duplicated(project_id))

  transform_years <- function(x) {
    # there are two types of occurences
    # either wrong or missing data, or a text string
    # text string is either "Funded in", "from to", or "since"
    # we keep "Funded in" as is and subtract 1 from "from" or "since"
    if (!is.na(x) & str_detect(x, "from|since")) {
    as.integer(str_extract(x, "\\d{4}"))-1
    } else {
      as.integer(str_extract(x, "\\d{4}"))
    }
  }

    transform_pi <- function(x) {
    # there are two types of occurences
    # either wrong or missing data, or a text string
    # text string is either "Funded in", "from to", or "since"
    # we keep "Funded in" as is and subtract 1 from "from" or "since"

    #x <- c("Professor Dr. Cornelis W. Passchier", "Professor Dr.-Ing. Erwin Stein", "Privatdozentin Dr. Anja Krieger-Liszkay")
    patterns <- c(
      ".*?dozent.*?\\b", #Dozent
      "prof.*?\\b", #Professor
      "\\b[a-z\\.-]{2,}\\b\\.", #Academic titles including hyphenated
      "," #comma
    )
    x <- str_trim(str_replace_all(tolower(x), paste0(patterns, collapse = "|"), ""))
    x <- str_replace(x, "^[a-z]{1}\\.", "") #single letter first name initial even after removing titles

  }

  transmuted_df <- raw_df |>
    select(
      project_id,
      program,
      title,
      abstract,
      pi,
      years
    ) |> 
    transmute(
      project_id = as.character(project_id),
      program = as.character(program),
      year = purrr::map_int(years, transform_years),
      title = as.character(title),
      abstract = as.character(abstract),
      pi_name_first = as.character(stringr::str_extract(transform_pi(pi), ".+?\\b")),
      pi_name_last = as.character(stringr::str_replace(transform_pi(pi), "^.*?\\b\\s(.*)", "\\1")),
      country = "DE",
      agency = "DFG"
    ) 
  transmuted_df |>
    finishing_touch()
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#'
#' @title read_input_csf
#' @param input_data_files
#' @param file_name
#' @return
#' @author hlageek
#' @export
read_input_csf <- function(input_data_files, file_name) {
  path_to_file <- input_data_files[basename(input_data_files) %in% file_name]
  raw_df_prep <- purrr::map(path_to_file, readr::read_csv) 
  raw_df <- dplyr::left_join(raw_df_prep[[1]], raw_df_prep[[2]], by = "kod_projektu") |> 
    janitor::clean_names() 

  transmuted_df <- raw_df |>
    select(
      kod_projektu,
      kod_programu,
      nazev_projektu_anglicky,
      cile_reseni_anglicky,
      jmeno,
      prijmeni,
      rok_zahajeni,
      statni_podpora_na_dobu_reseni
    ) |> 
    transmute(
      project_id = as.character(kod_projektu),
      program = as.character(kod_programu),
      year = as.integer(rok_zahajeni)-1, # minus one to account for call year
      title = as.character(nazev_projektu_anglicky),
      abstract = as.character(cile_reseni_anglicky),
      amount = as.integer(statni_podpora_na_dobu_reseni),
      pi_name_first = as.character(jmeno),
      pi_name_last = as.character(prijmeni),
      country = "CZ",
      agency = "CSF"
    ) 
  transmuted_df |>
    finishing_touch()
}