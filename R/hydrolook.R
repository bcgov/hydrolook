# Copyright 2017 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.



#' @title Hydrometric Network Diagnostic
#'
#' @description This package provides functions and reports to diagnose issues with the Water Survey of Canada Hydrometric network
#'
#' \code{hydrolook} package
#'
#' @docType package
#' @name hydrolook
#'
#' @importFrom tibble tibble
#' @importFrom readr read_csv
#' @importFrom readr cols
#' @importFrom xml2 read_html
#' @importFrom lubridate dmy_hm
#' @import tidyr
#' @import dplyr
#' @import knitr
#' @import rmarkdown
#' @import rvest
# @import tidyhydat
# @import kableExtra
#'
NULL

#' REmoves notes from R CMD check for NSE
#'
.onLoad <- function(libname = find.package("hydrolook"), pkgname = "hydrolook"){
  # CRAN Note avoidance
  if(getRversion() >= "2.15.1")
    utils::globalVariables(
      # Vars used in Non-Standard Evaluations, declare here to avoid CRAN warnings
      c("Raw_var", "date_time", "Date", "Time", "filename","Parameter",
        "." # piping requires '.' at times
      )
    )
  invisible()
}

