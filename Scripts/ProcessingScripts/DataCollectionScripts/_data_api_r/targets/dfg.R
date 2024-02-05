list(
  tar_target(
    name = dfg_catalogue_tsv,
    command = scrape_dfg_catalogue(
      gepris_url = "https://gepris.dfg.de/gepris/OCTOPUS?beginOfFunding=&bewilligungsStatus=&bundesland=DEU%23&context=projekt&einrichtungsart=-1&fachgebiet=%23&findButton=historyCall&gefoerdertIn=&ggsHunderter=0&hitsPerPage=50&index=1&nurProjekteMitAB=false&oldGgsHunderter=0&oldfachgebiet=%23&pemu=24&peu=%23&task=doKatalog&teilprojekte=true&zk_transferprojekt=false",
      outfile = here::here("Data", "OriginalData", "dfg_catalogue.tsv"), 
      sleep_time = 5,
      run = as.logical(Sys.getenv("API_RUN")) #as.logical(Sys.getenv("API_RUN"))
      ),
    format = "file"
  ),
tar_target(
    name = dfg_projects_tsv,
    command = scrape_dfg_projects(
      gepris_catalogue = dfg_catalogue_tsv,
      outfile = here::here("Data", "OriginalData", "dfg_projects.tsv"), 
      sleep_time = 5,
      run = as.logical(Sys.getenv("API_RUN")) #
      ),
    format = "file"
  )
)
