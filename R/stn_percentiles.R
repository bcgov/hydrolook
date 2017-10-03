# Copyright {YYYY} {COPYRIGHT_HOLDER}
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

#' A function to calculate percentiles of current data from historical data
#'
#' This function takes the 7 day average of
#'
#'
#library(dplyr)
#library(tidyhydat)
#
### sf layers
#nr_regions_sf <- sf::st_as_sf(bcmaps::nr_regions)
#
### Full of stations supposed to be real time network
#stns = tidyhydat::realtime_network_meta(PROV_TERR_STATE_LOC = "BC") %>%
#  st_as_sf(., coords = c("LONGITUDE", "LATITUDE"),
#           crs = 4326,
#           agr = "constant") %>%
#  transform_bc_albers() %>%
#  st_join(nr_regions_sf)
#
#
#
#
#STATIONS(STATION_NUMBER = stns) %>%
#
#
### download daily flows
#bcrl_stns <- DLY_FLOWS(STATION_NUMBER = stns)
#
### stn list that have data to use
#stns_hist <- unique(bcrl_stns$STATION_NUMBER)
#
### grab all the realtime data
#rt_data <- download_realtime_dd(STATION_NUMBER = stns_hist)
#
#tmp <- rt_data %>%
#  mutatE
#  padr::thicken(interval = "day") %>%
#  group_by(Date_day) %>%
#  summarise(Value = mean(Value, na.rm = TRUE))
#  mutate(Date2 = lubridate::ymd(Date))
#  filter(lubridate::month(Date) <= lubridate::month(Sys.Date()) &
#         lubridate::month(Date) >= lubridate::month(Sys.Date()-14) ) %>%
#
### Subset the hist data for past seven data and take 7 day average
### Then the columns is nested
#bcrl_stns %>%
#  filter(lubridate::month(Date) <= lubridate::month(Sys.Date()) &
#           lubridate::month(Date) >= lubridate::month(Sys.Date()-14) ) %>%
#  filter(lubridate::day(Date) <= lubridate::day(Sys.Date()) &
#           lubridate::day(Date) >= lubridate::day(Sys.Date()-14) ) %>%
#  mutate(Q7_day = zoo::rollapply(Value, 7, mean, na.rm = TRUE, partial = TRUE, fill = NA, align = "right")) %>%
#  #filter(STATION_NUMBER == "08NA002") %>% View()
#  mutate(day_month = paste0(day(Date),"-",month = month(Date)), year= year(Date)) %>%
#  group_by(day_month, STATION_NUMBER) %>%
#  nest()
#
#
#
### Use a nested column to find the distribution of a day
### Between June 1 and October 1
#hist_rl_dist <- HIST_FLOWS08HA %>%
#  #filter(year(Date) >= 2005) %>%
#  filter(!(month(Date)==2 & day(Date)==29)) %>%
#  mutate(Date2 = ymd(paste0("2017-",month(Date), "-",day(Date)))) %>%
#  select(-Date) %>%
#  group_by(Date2, STATION_NUMBER) %>%
#  nest() %>%
#  right_join(filter(ws_08HA_day, Parameter == "47"),
#             by = c("STATION_NUMBER" = "ID", "Date2" = "Date_day")) %>%
#  mutate(prctile = map2_dbl(data, Value, ~ecdf(.x$FLOW)(.y))) %>%
#  left_join(bcstations, by = c("STATION_NUMBER"))
#
### Spatial Data
#nr_regions_sf <- sf::st_as_sf(bcmaps::nr_regions)
#wsc_drainages_sf <- sf::st_as_sf(bcmaps::wsc_drainages)
#watercourses_5M_sf <- sf::st_as_sf(bcmaps::watercourses_5M)
#
#stations_regions <- STATIONS(hydat_path = "H:/Hydat.sqlite3", STATION_NUMBER = "ALL", PROV_TERR_STATE_LOC = "BC") %>%
#  st_as_sf(., coords = c("LONGITUDE", "LATITUDE"),
#           crs = 4326,
#           agr = "constant") %>%
#  transform_bc_albers() %>%
#  st_join(nr_regions_sf) %>%
#  st_join(wsc_drainages_sf) %>%
#  #filter(is.na(WSCSSDA_EN)) %>%
#  select(STATION_NUMBER, STATION_NAME, HYD_STATUS, REAL_TIME, ORG_UNIT_N, WSCMDA_EN, WSCMDA, WSCSDA_EN, WSCSDA, WSCSSDA_EN, WSCSSDA) %>%
#  mutate(WSCSSDA_EN = forcats::fct_reorder(WSCSSDA_EN, str_order(WSCSSDA)))
#
### Get historical data
#HIST_LEVELS <- DLY_LEVELS(STATION_NUMBER = stns)
#
### Use a nested column to find the distribution of a day
### Between June 1 and October 1
#hist_rl_dist <- HIST_FLOWS08HA %>%
#  #filter(year(Date) >= 2005) %>%
#  filter(!(month(Date)==2 & day(Date)==29)) %>%
#  mutate(Date2 = ymd(paste0("2017-",month(Date), "-",day(Date)))) %>%
#  select(-Date) %>%
#  group_by(Date2, STATION_NUMBER) %>%
#  nest() %>%
#  right_join(filter(ws_08HA_day, Parameter == "47"),
#             by = c("STATION_NUMBER" = "ID", "Date2" = "Date_day")) %>%
#  mutate(prctile = map2_dbl(data, Value, ~ecdf(.x$FLOW)(.y))) %>%
#  left_join(bcstations, by = c("STATION_NUMBER"))
#
