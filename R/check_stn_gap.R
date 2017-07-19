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
#' check_stn_gap(STATION_NUMBER = c("07EC003","08NL071"), PROV_TERR_STATE_LOC = "BC")
#'
#' check_stn_gap(STATION_NUMBER = "07EC003", PROV_TERR_STATE_LOC = "BC", gap_thres = 300)
#'

check_stn_gap <- function(STATION_NUMBER = "ALL", PROV_TERR_STATE_LOC, gap_thres = 60, num_gaps = 5, tracker = FALSE) {

  if(missing(STATION_NUMBER) | missing(PROV_TERR_STATE_LOC))
    stop("STATION_NUMBER or PROV_TERR_STATE_LOC argument is missing. These arguments must match jurisdictions.")

  stations = STATION_NUMBER
  prov = PROV_TERR_STATE_LOC

  ## Pull all the stations that are currently realtime
  allstations = tidyhydat::download_network(PROV_TERR_STATE_LOC = prov)


  ##Which stations should perform the test on?
  if (stations[1] == "ALL") {
    loop_stations = allstations$STATION_NUMBER
    #loop_stations = c("07EA005","07FD004","10BE001","08LG067","08NN023", "10BE009")
  } else {
    loop_stations = stations
  }


  df <- c()
  for (i in 1:length(loop_stations)) {
    if (tracker == TRUE){
    cat(paste0("Checking station: ", loop_stations[i], "\n"))
    }

    rtdata = tryCatch(
      #HYDAT::RealTimeData(station_number = loop_stations[i], prov_terr_loc = "BC"),
      tidyhydat::download_realtime(STATION_NUMBER = loop_stations[i], PROV_TERR_STATE_LOC = prov),
      error = function(e)
        data.frame(Status = e$message)
    )



    ## Is there a status column?
    if (!"Status" %in% colnames(rtdata)) {
      interval = diff(rtdata$date_time)

      ########################################################################
      # Criteria1: Does this station have any data gaps larger than "gap_thres?" #
      ########################################################################
      Criteria1 = length(which(interval > gap_thres)) > 0

      ##################################################################
      # Criteria2: Are there more than "num_gaps" gaps that are longer than 2o minutes? #
      ##################################################################
      #  How frequent are the gaps? Is the station frequently cutting out?
      ##The most common values in a dataframe?
      intermittent_df = as.data.frame(table(as.numeric(interval)), stringsAsFactors = FALSE)
      ## Need to change Var1 to a number
      intermittent_df$Var1 = as.numeric(intermittent_df$Var1)

      Criteria2 = nrow(intermittent_df[intermittent_df$Var1 >= 20, ]) > num_gaps



      ## Use the criteria to make a sensible dataframe
      if (Criteria1 == TRUE |  Criteria2 == TRUE) {
        ## Criteria column outputs which criteria was meet individually
        u = data.frame(
          STATION_NUMBER = loop_stations[i],
          Status = "in datamart",
          Criteria1 = ifelse(Criteria1 == TRUE, "TRUE", "FALSE"),
          Criteria2 = ifelse(Criteria2 == TRUE, "TRUE", "FALSE")
        )
        #df = rbind(u, df)
      } else {
        u = data.frame(
          STATION_NUMBER = loop_stations[i],
          Status = "in datamart",
          Criteria1 = "FALSE",
          Criteria2 = "FALSE")
      }

    } else { ## If there is no status column that means there was error - output error
      u = data.frame(
        STATION_NUMBER = loop_stations[i],
        Status = "url not located; check datamart",
        Criteria1 = NA,
        Criteria2 = NA
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
    df = dplyr::right_join(allstations, df, by = c("STATION_NUMBER"))
    df$TIMEZONE <- NULL ## don't need the timezone column
    df$PROV_TERR_STATE_LOC <- NULL ## don't need the prov_terr_loc column

    return(df)
  } else {
    cat(paste0("Either no interval greater than ", gap_thres, " minutes or \n not more than ", num_gaps, " 20 minutes gaps"))
  }

}




