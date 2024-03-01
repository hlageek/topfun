finishing_touch <- function(x) {
 x |> 
 # replace empty text with NAs
 dplyr::mutate(dplyr::across(tidyselect::where(is.character), ~dplyr::na_if(.x, "")))  |> 
 # ensure no trailing whitespace on output
 dplyr::mutate(dplyr::across(tidyselect::everything(), trimws))
}

filter_by_years <- function(x, years) {
  if (!is.null(years)) {
    x <- x |>
      filter(
        year <= max(years),
        year >= min(years),
      )
  }
  return(x)
}