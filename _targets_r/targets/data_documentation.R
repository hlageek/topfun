    # Make documentation for data
    # moving rendered document to `docs` folder
    # temporary hack until output path can be specified directly 
    # in `tar_render`
    tarchetypes::tar_render(
        data_documentation,
        path = "Rmd/data_documentation.Rmd", 
        params = list(targets_store = "_targets")
    )
