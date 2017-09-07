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


#' @title Check for interval threshold value
#'
#' @description Check all realtime hydrometric stations in the Federal-Provincial network that exceed a user supplied time gap in records (defaults to the 60 minutes). \code{STATION_NUMBER} and
#' \code{PROV_TERR_STATE_LOC} must both be supplied.
#' @param STATION_NUMBER Water Survey of Canada station number. No default. Can also take the "ALL" argument.
#' Currently you can't mix stations from two difference jurisdictions. See examples.
#' @param PROV_TERR_STATE_LOC Province, state or territory. Defaults to "BC". Will not accept ALL.
#' @param gap_thres Threshold (in minutes) whereby there is a gap in the stations realtime data. Defaults to 60 minutes. DOES NOT CONNECT TO num_gaps
#' @param num_gaps Number of gaps that exceed 20 minutes. Defaults to 5.
#' @param tracker Should a progress list of stations be printed while the analysis is executed? Defaults to FALSE
#' @return A dataframe containing all the stations (and associated spatial information) that exceed the gap criteria of gap_thres.
#'
#' @export
#'
#' @examples
#' \donttest{
#' check_stn_variability(STATION_NUMBER = c("07FC001","08NL071"))
#'
#' check_stn_variability(PROV_TERR_STATE_LOC = "PE", gap_thres = 300)
#' }
#'

check_stn_variability <- function(STATION_NUMBER = NULL, PROV_TERR_STATE_LOC = NULL, gap_thres = 60, num_gaps = 5, tracker = FALSE) {

  if(is.null(STATION_NUMBER) && is.null(PROV_TERR_STATE_LOC))
    stop("STATION_NUMBER or PROV_TERR_STATE_LOC argument is missing. One argument must be supplied")

  stations = STATION_NUMBER
  prov = PROV_TERR_STATE_LOC

  ## If station is omitted
  if(is.null(stations)){
    allstations_list = tidyhydat::realtime_network_meta(PROV_TERR_STATE_LOC = prov)
    loop_stations = allstations_list$STATION_NUMBER
  }

  ## If prov is omitted
  if(is.null(prov)){
  loop_stations = stations
  allstations_list = tibble::tibble(STATION_NUMBER = stations)
  }



  df <- c()
  for (i in 1:length(loop_stations)) {
    if (tracker == TRUE){
    cat(paste0("Checking station: ", loop_stations[i], "\n"))
    }

    rtdata = tryCatch(
      tidyhydat::download_realtime_dd(STATION_NUMBER = loop_stations[i]),
      error = function(e)
        data.frame(Status = e$message)
    )



    ## Is there a status column?
    if (!"Status" %in% colnames(rtdata)) {

      ##Take only the level data
      rtdata = dplyr::filter(rtdata, Parameter == "LEVEL")




      rtdata$Value_sd = stats::sd(rtdata$Value, na.rm = TRUE)
      rtdata$diff_var = c(NA, diff(rtdata$Value))



      ## Are there any values more than 2SD away from the mean?
      if(any(rtdata$diff_var > 1) == TRUE){
        Criteria3 = TRUE
      } else{
        Criteria3 = FALSE
      }

      ## If the station was flatlining SD would zero
      if(any(rtdata$Value_sd == 0) == TRUE){
        Criteria4 = TRUE
      } else{
        Criteria4 = FALSE
      }




      ## Use the criteria to make a sensible dataframe
      if (Criteria3 == TRUE |  Criteria4 == TRUE) {
        ## Criteria column outputs which criteria was meet individually
        u = data.frame(
          STATION_NUMBER = loop_stations[i],
          Criteria3 = ifelse(Criteria3 == TRUE, "TRUE", "FALSE"),
          Criteria4 = ifelse(Criteria4 == TRUE, "TRUE", "FALSE")
        )
        #df = rbind(u, df)
      } else {
        u = data.frame(
          STATION_NUMBER = loop_stations[i],
          Criteria3 = "FALSE",
          Criteria4 = "FALSE")
      }

    } else { ## If there is no status column that means there was error - output error
      u = data.frame(
        STATION_NUMBER = loop_stations[i],
        Status = "url not located; check datamart",
        Criteria3 = NA,
        Criteria4 = NA
      )
      #df = rbind(u, df)
    }
    df = rbind(u, df)

    rm("rtdata")

  }

  ## Check if any stations met the criteria?
  ## If so join with original allstations dataframe for a nice output
  if (!is.null(df)) {
    df$STATION_NUMBER = as.character(df$STATION_NUMBER)
    df = dplyr::right_join(allstations_list, df, by = c("STATION_NUMBER"))
    df$TIMEZONE <- NULL ## don't need the timezone column
    df$PROV_TERR_STATE_LOC <- NULL ## don't need the prov_terr_loc column

    return(df)
  } else {
    cat(paste0("Either no interval greater than ", gap_thres, " minutes or \n not more than ", num_gaps, " 20 minutes gaps"))
  }

}




