#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param models
#' @param dim
#' @return
#' @author hlageek
#' @export
combine_topic_models <- function(models = list(), 
                                 dim) {

    models  |> 
        map(dim) |> 
        map(bind_rows, .id = "level")  |> 
        bind_rows(.id = "agency") |> 
        mutate(model = dim)
}
