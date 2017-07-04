#' @title Check for interval threshold value
#'
#' @description Check all realtime hydrometric stations in the Federal-Provincial network that exceed a user supplied time gap in records (defaults to the 60 minutes).
#' @param stations select one station of all. Currently accepts either one station or "ALL"
#' @param gap_thres Threshold (in minutes) whereby there is a gap in the stations realtime data. Defaults to 60 minutes. DOES NOT CONNECT TO num_gaps
#' @param num_gaps Number of gaps that exceed 20 minutes. Defaults to 5.
#' @return A dataframe containing all the stations (and associated spatial information) that exceed the gap criteria of gap_thres.
#'
#' @export
#'
#' @examples
#' check_stn_gap(stations = "07EC003")
#'
#' check_stn_gap(stations = "07EC003", gap_thres = 300)
#'

check_stn_gap <- function(stations = "ALL", gap_thres = 60, num_gaps = 5) {

  ## Pull all the stations that are currently realtime
  all_stations = HYDAT::RealTimeNetwork()

  ## Find the subset that is BC
  bcstations = all_stations[all_stations$prov_terr_loc == "BC", ]
  ## Error stations TODO: A better way to handle this
  #bcstations = bcstations[!bcstations$station_number == "07FD004", ]

  ##Which stations should perform the test on?
  if (stations == "ALL") {
    loop_stations = bcstations$station_number
    #loop_stations = c("07EA005","07FD004")
  } else {
    loop_stations = stations
  }

  #loop_stations <- c("07EC003")
  #i <- "07EC003"
  #i <- "10BE001"
  #i <- "08CE001"
  #gap_thres = 3600
  #num_gaps = 5
  ## Loop  to find
  df <- c()
  for (i in 1:length(loop_stations)) {
    #cat(paste0("Checking station: ", i, "\n"))

    rtdata = tryCatch(
      HYDAT::RealTimeData(station_number = loop_stations[i], prov_terr_loc = "BC"),
      error = function(e)
        data.frame(Status = e$message)
    )

    ## Is there a status column?
    if (is.null(rtdata$Status) == TRUE) {
      interval = diff(rtdata$date_time)

      ########################################################################
      # Criteria 1: Does this station have any data gaps larger than 1 hour? #
      ########################################################################
      Criteria1 = length(which(interval > gap_thres)) > 0

      ##################################################################
      # Are there more than five gaps that are longer than 2o minutes? #
      ##################################################################
      # Criteria 2: How frequent are the gaps? Is the station frequently cutting out?
      ##The most common values in a dataframe?
      intermittent_df = as.data.frame(table(as.numeric(interval)), stringsAsFactors = FALSE)
      ## Need to change Var1 to a number
      intermittent_df$Var1 = as.numeric(intermittent_df$Var1)

      Criteria2 = nrow(intermittent_df[intermittent_df$Var1 >= 20, ]) > num_gaps




      if (Criteria1 == TRUE |  Criteria2 == TRUE) {
        ## Criteria column outputs which criteria was meet individually
        u = data.frame(
          station_number = loop_stations[i],
          Status = "in datamart",
          Criteria1 = ifelse(Criteria1 == TRUE, "TRUE", "FALSE"),
          Criteria2 = ifelse(Criteria2 == TRUE, "TRUE", "FALSE")
        )
        #df = rbind(u, df)
      }
    } else { ## If there is no status column that means there was error - output error
      u = data.frame(
        station_number = loop_stations[i],
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
  ## If so join with original bcstations dataframe for a nice output
  if (!is.null(df)) {
    df$station_number = as.character(df$station_number)
    df = dplyr::right_join(bcstations, df, by = c("station_number"))
    df$timezone <- NULL ## don't need the timezone column
    df$prov_terr_loc <- NULL ## don't need the prov_terr_loc column
    return(df)
  } else {
    cat(paste0("Either no interval greater than ", gap_thres, " minutes or \n not more than ", num_gaps, " 20 minutes gaps"))
  }

}



    ### Step 2: Create a vector that spans the full range of time at every five minute interval
    #full_date_vector = data.frame(date_time = seq(min(rtdata$date_time), max(rtdata$date_time), by = "5 min"),
    #                              station_number = i)
    #full_date_vector$station_number <- as.character(full_date_vector$station_number)
#
    ### Step 3: Join rtdata and full_date so that missing date show up as NA
    #full_df = dplyr::right_join(rtdata,
    #                    full_date_vector,
    #                    by = c("date_time", "station_number"))
#
    ### Step 4a: Remove left over NA's for station in .csv's
    #full_df2 = dplyr::filter(full_df, !is.na(station_number))
#
    ### Step 4: Find if there any NA's for the time series
    #num_missing_value = nrow(dplyr::filter(full_df, is.na(qr)))
#
    ## Conditional if there are more than 1 missing value
    #u = data.frame(station_number = unique(full_df2$station_number),
    #               num_missing_value)
    #df = rbind(u, df)

    #}, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})



