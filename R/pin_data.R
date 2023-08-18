#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param board
#' @param src
#' @return
#' @author hlageek
#' @export
pin_data <- function(board = topfun_board, src = NULL, src_format = NULL, name = NULL, title = NULL, description = NULL, metadata = NULL, versioned = FALSE) {
 
 data_df <- switch(src_format,
    "tsv" = readr::read_tsv(src, show_col_types = FALSE),
    "csv_fr" = readr::read_delim(src,
                                 delim = ";",
                                 locale = locale("fr",
                                                 decimal_mark = ".")),
    "csv2" = readr::read_csv2(src)
 )
 data_df_file <- paste0(tempfile(), ".qs")

 qs::qsave(data_df, data_df_file) 
 
 pins::pin_upload(board = board, 
                 paths = data_df_file, 
                 name = name, 
                 title = title,
                 description = description,
                 metadata = metadata,
                 versioned = versioned)
  return(data_df)


}
