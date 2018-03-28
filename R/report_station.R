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

#' @title Station report generator
#' @description Commands to generate reports
#'
#' @return Will output a report to a report/station_report directory
#'
#' @param output_type the type of file to be outputted. Currently html and pdf are supported. defaults to pdf
#' @param STATION_NUMBER Water Survey of Canada station number. No default.
#' @family report_generators
#' @export
#'
#' @examples
#' \donttest{
#' report_station(output_type = "pdf", STATION_NUMBER = "08EB005")
#' report_station(output_type = "pdf", STATION_NUMBER = "08MF005")
#' report_station(output_type = "pdf", STATION_NUMBER = "07EA005")
#' }
#'
#'
report_station = function(output_type = "pdf", STATION_NUMBER = NULL){

  if(!output_type %in% c("pdf","html")){
    stop('output_type must be "pdf" or "html"')
  }

  ## Create organize fill structure
  stn <- tidyhydat::hy_stations(STATION_NUMBER)

  dir_here <- file.path("report/station_reports", paste0(stn$STATION_NUMBER," ",stn$STATION_NAME))

  if(!dir.exists(dir_here)) {
    dir.create(dir_here)
  }

  input_path <- system.file("templates", "station_report.Rmd", package="hydrolook")

  rmarkdown::render(input_path,
                    output_format = paste0(output_type,"_document"),
                    params = list(
                      table_format = ifelse(output_type == "pdf","latex","html"),
                      stns = STATION_NUMBER),
                    output_file = paste0("STN_",STATION_NUMBER,"_",Sys.Date(),".",output_type),
                    output_dir = dir_here
  )
}
