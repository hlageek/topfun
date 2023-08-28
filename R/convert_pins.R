#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param pinboard
#' @param pin_names
#' @return
#' @author hlageek
#' @export
convert_pins <- function(pinboard, pin_names) {

    stats::setNames(
      purrr::map(pin_names, .f = function(x) {
        list(
          "path" = paste0(
            pins::pin_meta(pinboard, x)$local$dir,
            .Platform$file.sep,
            pins::pin_meta(pinboard, x)$file
          ),
          "metadata" = pins::pin_meta(pinboard, x)
        )
      }),
      pin_names
    )

}
