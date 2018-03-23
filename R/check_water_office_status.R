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

#' @title A function to determine station status
#' @description This function scrapes data off the ECCC water office and outputs a summary of station(s) status
#'
#' @param station_number WSC station number
#' @param print_url logical: Should the Water Office url be printed?
#' @param cpoy_url logical: Should the Water Office url be copied to a clipboard (windows only)?
#'
#' @export
#'
#' @examples
#' \dontrun{
#' check_water_office_status("08MF005",print_url = TRUE)
#'
#' ## to get around 20 station limit for the water office
#' if (require("purrr")) {
#' stns <- tidyhydat::realtime_stations(prov_terr_state_loc = "BC")
#' stns_split <- split(stns$STATION_NUMBER, (seq(length(stns$STATION_NUMBER))) %/% 20)
#' map_dfr(stns_split, ~ check_water_office_status(.x))
#' }
#' }
#'
check_water_office_status <- function(station_number, print_url = FALSE, copy_url = FALSE){

  if(length(station_number) > 20) stop("Can only request 20 stations at a time")

  ## Create url request
  base_url <- "https://wateroffice.ec.gc.ca/search/real_time_results_e.html?search_type=station_number&station_number="
  stns <- paste0(station_number, collapse = "%2C")
  extra_end_url <- "&gross_drainage_operator=%3E&gross_drainage_area=&effective_drainage_operator=%3E&effective_drainage_area="

  full_url <- paste0(base_url, stns, extra_end_url)

  if(print_url == TRUE){
    cat(full_url,"\n")
  }

  if(copy_url == TRUE){
    utils::writeClipboard(full_url)
  }

  html <- xml2::read_html(full_url)

  search_results <- rvest::html_nodes(html, "td")
  search_results <- rvest::html_text(search_results)
  search_results <- matrix(search_results, nrow = length(station_number), byrow = TRUE)
  search_results <- tibble::as_tibble(search_results)
  search_results <- dplyr::select(search_results, -V1)

  colnames(search_results) <- c("STATION_NAME", "PROV_TERR_STATE_LOC","STATION_NUMBER", "DATA_LAST_SIX_HOURS","OPERATION_SCHEDULE")

  search_results

}
