# Copyright 2018 Province of British Columbia
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

#' @title Check for difference in datamart reported stations
#' @description Check for differences in datamart reported stations
#'
#' @param prov_terr_state_loc Province, state or territory.
#'
#' @examples
#' \dontrun{
#' check_datamart_status(prov_terr_state_loc = "PE")
#' }
#'
#' @export

check_datamart_status <- function(prov_terr_state_loc = NULL) {
  ## Create url request
  base_url <- "http://dd.weather.gc.ca/hydrometric/csv/"

  daily <- "/daily"
  hourly <- "/hourly"

  ## Create urls
  daily_url <- paste0(base_url, prov_terr_state_loc, daily)
  hourly_url <- paste0(base_url, prov_terr_state_loc, hourly)

  ## daily stations
  html <- xml2::read_html(daily_url)
  search_results <- rvest::html_nodes(html, "a")
  search_results <- rvest::html_text(search_results)
  daily_stations <- substr(search_results[6:(length(search_results) - 1)], 4, 10)

  ## hourly stations
  html <- xml2::read_html(hourly_url)
  search_results <- rvest::html_nodes(html, "a")
  search_results <- rvest::html_text(search_results)
  hourly_stations <- substr(search_results[6:(length(search_results) - 1)], 4, 10)

  ## Get posted metadata
  metadata_stations <- tidyhydat::realtime_stations(prov_terr_state_loc)$STATION_NUMBER

  check_diff(daily_stations, hourly_stations)
  check_diff(daily_stations,metadata_stations)
  check_diff(hourly_stations,daily_stations)
  check_diff(hourly_stations,metadata_stations)
  check_diff(metadata_stations, daily_stations)
  check_diff(metadata_stations, hourly_stations)


  invisible()
}



check_diff <- function(x, y, ...){
  ## Do the setdiffs
  dd_diff <- dplyr::setdiff(x, y, ...)

  empty_charac <- character(0)

  ## Better names for message
  y_sub <- gsub("_stations","",deparse(substitute(y)))
  x_sub <- gsub("_stations","",deparse(substitute(x)))

  if(!identical(empty_charac, dd_diff)){
    message(paste0("Station in ",x_sub, " not present in ", y_sub,":"))
    message(paste0(dd_diff, collapse = ", "))
  }
}



