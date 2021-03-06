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


#' @title Check real time lag of realtime stations
#'
#' @description Check lag of real time stations using most recent observations and modification date of most recent file.
#'
#' @param station_number Water Survey of Canada station number. No default. Can also take the "ALL" argument.
#' Currently you can't mix stations from two difference jurisdictions. See examples.
#' @param prov_terr_state_loc Province, state or territory. Defaults to "BC". Will not accept ALL.
#' @param tracker Should a progress list of stations be printed while the analysis is executed? Defaults to FALSE
#' @param data_interval Examine hourly or daily data? Defaults to hourly
#'
#' @return
#' \itemize{
#' \item STATION NUMBER Water Survey of Canada station number
#' \item time_obs Date and time of most recent observation from that station
#' \item time_mod Date and time of data file upload to datamart
#' \item time_lag Time difference (in hours) between \code{time_mod} and \code{time_obs}. This value represents
#' the time delay for the network from data acquisition to data upload.
#' }
#'
#' @examples
#' \donttest{
#' check_realtime_lag(station_number = c("08NL071","05QB002"))
#'
#' ## To check all stations in PEI:
#' check_realtime_lag(prov_terr_state_loc = "PE")
#' }
#'
#'
#' @export

check_realtime_lag <- function(station_number = NULL, prov_terr_state_loc = NULL,
                               data_interval = "hourly", tracker = FALSE) {
  prov = prov_terr_state_loc

  #if(prov == "ALL") {message("ALL is not valid input. Please select individual jurisdictions")}

  if(!is.null(station_number)){
    stns = station_number
    choose_df = tidyhydat::realtime_stations()
    choose_df = dplyr::filter(choose_df, STATION_NUMBER %in% stns)
    choose_df = dplyr::select(choose_df, STATION_NUMBER, PROV_TERR_STATE_LOC)
  }

  if(is.null(station_number) ){
    choose_df = tidyhydat::realtime_stations(prov_terr_state_loc = prov_terr_state_loc)
    choose_df = dplyr::select(choose_df, STATION_NUMBER, PROV_TERR_STATE_LOC)
  }

  #if(is.null(STATION_NUMBER)) {
  #  ## Download province stations that are real time
  #  full_net <- tidyhydat::realtime_stations(PROV_TERR_STATE_LOC = prov)
  #  ## Add them to the loop
  #  stns = full_net[full_net$PROV_TERR_STATE_LOC == prov,]$STATION_NUMBER
  #}
#
  #if(is.null(PROV_TERR_STATE_LOC)){
  #  stns = STATION_NUMBER
  #
  #}

  lag_c <- c()

  # Define column names as the same as HYDAT
  colHeaders <- c("STATION_NUMBER", "date_time", "LEVEL", "LEVEL_GRADE", "LEVEL_SYMBOL", "LEVEL_CODE",
                  "FLOW", "FLOW_GRADE", "FLOW_SYMBOL", "FLOW_CODE")

  for (i in 1:nrow(choose_df) ){
    if (tracker == TRUE){
    cat(paste0("Station:",stns[i],"\n"))
    }
    ## Specify from choose_df
    STATION_NUMBER_SEL = choose_df$STATION_NUMBER[i]
    PROV_SEL = choose_df$PROV_TERR_STATE_LOC[i]

    ### Date Modified
    base_url = "http://dd.weather.gc.ca/hydrometric"
    ## Currently only implemented for BC

    # build URL

    url <- sprintf("%s/csv/%s/%s", base_url, PROV_SEL, data_interval)
    infile <- sprintf("%s/%s_%s_%s_hydrometric.csv", url, PROV_SEL, STATION_NUMBER_SEL, data_interval)

    ## Scrape web data
    time_mod <- xml2::read_html(url) %>%
      rvest::html_nodes("pre") %>%
      rvest::html_text() %>% ##Scraping data
      readr::read_csv(skip = 1, col_names = "Raw_var") %>% ##turn data into dataframe
      dplyr::slice(1:(nrow(.)-1)) %>% ##remove last row
      tidyr::separate(Raw_var, c("filename","Date","Time","Size"),
                      sep = " " , extra = "drop", fill = "right") %>% ## Separate by space
      tidyr::unite(date_time, Date, Time, sep = " ") %>% ## Unite data
      dplyr::mutate(date_time = lubridate::dmy_hm(date_time)) %>%
      dplyr::mutate(STATION_NUMBER = substr(filename, 4,10)) %>%
      dplyr::filter(STATION_NUMBER == STATION_NUMBER_SEL) %>%
      dplyr::pull(date_time)


    ### Is there any data in the webscrape?
    ## If yes then proceed and download the datafile
    ## If no then reproduce NA's
    if (length(time_mod) == 0) {
      time_obs = NA
      time_mod = NA
    } else{
      rl <-
        readr::read_csv(
          infile[1],
          skip = 1,
          col_names = colHeaders,
          col_types = readr::cols(
            STATION_NUMBER = readr::col_character(),
            date_time = readr::col_datetime(),
            LEVEL = readr::col_double(),
            LEVEL_GRADE = readr::col_character(),
            LEVEL_CODE = readr::col_integer(),
            FLOW = readr::col_double(),
            FLOW_GRADE = readr::col_character(),
            FLOW_SYMBOL = readr::col_character(),
            FLOW_CODE = readr::col_integer()
          )
        )
      time_obs <-
        max(rl$date_time) ##Find the most recent observation
    }



    ### Pull everything together
    lag <- dplyr::tibble(
      STATION_NUMBER = STATION_NUMBER_SEL,
      time_obs = time_obs,
      time_mod = time_mod
    )

    ## Layer each (bind) dataframe on top of each other
    lag_c = dplyr::bind_rows(lag, lag_c)


  }
  lag_c$time_lag = difftime(lag_c$time_mod,lag_c$time_obs)
  lag_c$time_lag_num = as.double(lag_c$time_lag, units= "hours")

  return(lag_c)
}

