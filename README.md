# TOPFUN project

<!-- badges: start -->

<!-- badges: end -->

This repository contains code for the The Impact of Research Funding on Research Topics (TOPFUN)
 project, a collaboration between [ELICO](https://elico-recherche.msh-lse.fr/) ([project](https://elico-recherche.msh-lse.fr/programme/impact-research-funding-research-topics-topfun)) and [CSTSS](https://stss.flu.cas.cz/) (project [8J20FR026](https://starfos.tacr.cz/en/project/8J20FR026)).

## Instructions

To reproduce the project pipeline, run the following:

-   in Terminal:

    -   `git clone https://github.com/hlageek/funding-topics.git` to clone the repository

-   in R console:

    -   `renv::restore()`\` to restore the package environment of the project

    -   `targets::tar_make()` to rebuild the targets

You can then load all the built targets into the `R` environment by running `targets::tar_load(everything())`, or alternatively load the individual targets with `targets::tar_load(NAME_OF_TARGET)`.

## Structure of the repository

`/tar_plan.Rmd` definition of targets and documentation of the pipeline

`/_targets.R`script for execution of the pipeline

`/data/data_raw/*`data originating outside of the pipeline

`/data/data_derived/*`data produced inside the pipeline

`/docs/*` documents (typically `html` output of `Rmd` files) produced inside the pipeline

`/Rmd/*` Rmd notebooks used to generate the content of `/docs`

`/R/*` functions used by the pipeline
