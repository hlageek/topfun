#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| label: data_get_api
#| eval: false
quarto::quarto_render("_data_api.qmd", quiet = TRUE)
targets::tar_make(script = "_data_api.R", store = "_data_api")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| label: data_get_downloads 
#| eval: false
quarto::quarto_render("_data_get.qmd", quiet = TRUE)
targets::tar_make(script = "_data_get.R", store = "_data_get")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| label: data_export
#| eval: false
quarto::quarto_render("_data_process.qmd", quiet = TRUE)
targets::tar_make(script = "_data_process.R", store = "_data_process")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| label: data_import
#| eval: false
quarto::quarto_render("_data_import.qmd", quiet = TRUE)
targets::tar_make(script = "_data_import.R", store = "_data_import")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| label: quarto-projects
#| eval: false
quarto::quarto_render("_data_analyze.qmd", quiet = TRUE)
targets::tar_make(script = "_data_analyze.R", store = "_data_analyze")
#
#
#
#
#
#
#
#
#
#| label: publish-docs
#| eval: false
#From: https://gist.github.com/cobyism/4730490
system("quarto render")
system("touch _book/.nojekyll")
system("git add . && git commit -m 'Update gh-pages'")
system("git subtree push --prefix _book origin gh-pages")
#
#
#
#
#
