#' @title bind_realtime
#'
#' @description Check all realtime hydrometric stations in the Federal-Provincial network that exceed a user supplied time gap in records (defaults to the 60 minutes).
#' @param stations station to pull data
#'
#' @export
#'
#'

bind_realtime <- function(stations = stations) {

  ## Pull all the stations that are currently realtime
  all_stations = HYDAT::RealTimeNetwork()

  ## Find the subset that is BC
  bcstations = all_stations[all_stations$prov_terr_loc == "BC", ]
  ## Error stations TODO: A better way to handle this
  bcstations = bcstations[!bcstations$station_number == "07FD004", ]

  ##Which stations should perform the test on?
  loop_stations = stations

  #loop_stations <- c("07EC003","07FD001")
  ## Loop  to find
  df <- c()
  for (i in loop_stations) {

    rtdata = HYDAT::RealTimeData(station_number = i, prov_terr_loc = "BC")
    df = rbind(df, rtdata)

  }
  return(df)

}

