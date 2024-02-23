# README.md

<!-- badges: start -->

<!-- badges: end -->

This repository contains code for the analysis of topic portfolios for several European science funding agencies.

## Instructions

To reproduce the project, run the following:

1. in Terminal:
    - `git clone https://github.com/hlageek/funding-topics.git` to clone the repository
1. in R console:
    - `install.packages("renv")` to enable `renv` dependencies management for the project
    - `renv::restore()`\` to restore the package environment of the project
    - `quarto::quarto_render(as_job = FALSE)` to render all `quarto`-defined pipelines for `targets`
    - `targets::tar_make()` to compile analytical pipelines and generate contents of the `Outputs` folder

The `scripts/main.qmd` `quarto` file offers a more finegrained control over the exectution of individual project pipelines.

Each pipeline has its own `quarto` file located in the subfolders of `scripts` folder.

Automatically **generated** files and folders as well as essential **helper and configuration** files and folders have names beginning with underscore: `_`. The necessary configuration for the repository is defined in `_quarto.yml` for `quarto` and `_targets.yaml` for `targets`.

## Structure of the repository

The repository is structured according to [TIER Protocol 4.0](https://www.projecttier.org/tier-protocol/protocol-4-0) specification for conducting and documenting an empirical research project with additional requirements for `quarto` and `targets` projects to construct a reproducible project environment.

root
  - `_book/` 
    - documentation files, generated by quarto
- `R/` 
   - R functions
 - `renv/`
   - record of packages used
 - `data/`
   - `collected_data/`
     - files obtained through downloads, webscraping, APIs
   - `input_data/`
     - files retrieved from OSF repository of collected data
    - `metadata/`
      - files documenting input data
   - `intermediate_data/`
     - files for modeling
  - `analysis_data/`
    - files for analysis
- `scrapbook/`
  - archived script files
- `scripts/`
  - `data_collection_scripts/`
    - pipelines for collecting data
  - `processing_scripts/`
    - pipelines for processing input data
  - `data_appendix_scripts/`
    - scripts for data documentation
  - `data_analysis_scripts/`
    - pipelines for data analysis
  - main file for pipelines orchestration
  - default targets pipeline
- `README.md` basic instructions  
- `_quarto.yml` Quarto project configuration
- `index.qmd` Index file for Quarto project
- `_targets.yaml` Targets projects configuration
