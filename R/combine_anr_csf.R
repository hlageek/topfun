#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param data_anr_sel
#' @param data_csf
#' @return
#' @author hlageek
#' @export
combine_anr_csf <- function(data_anr_sel, 
                            data_csf_sel,
                            data_erc_sel) {

    bind_rows(.id = "country",
    
    
    "fr" = data_anr_sel %>% 
        select(code = code_du_projet,
               title = titre,
               abstract = resume,
               year = annee_de_financement,
               type,
               amount = montant,
               duration)
    
    ,
    
    "cz" = data_csf_sel %>% 
        select(code = project_code,
               title = title_eng,
               abstract,
               year = year_start,
               type,
               amount = total,
               duration)
    ,
    
    "eu" = data_erc_sel %>% 
        select(code,
               title,
               abstract = objective,
               year,
               type,
               amount = totalCost,
               duration)
    ) %>% 
        mutate(type = if_else(
            str_detect(
                type, 
                "BLANC|Consol|Standard"),
            "senior",
            "junior"
            )
            )

}
