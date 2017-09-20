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
#' @param STATION_NUMBER Water Survey of Canada station number. No default.
#' @param PROV_TERR_STATE_LOC Province, state or territory. See also for argument options.
#'
#' @export
#'
#' @examples
#' \donttest{
#' station_report(output_type = "pdf", STATION_NUMBER = "08EB005", PROV_TERR_STATE_LOC = "BC")
#' station_report(output_type = "pdf", STATION_NUMBER = "08MF005", PROV_TERR_STATE_LOC = "BC")
#' station_report(output_type = "pdf", STATION_NUMBER = "07EA005", PROV_TERR_STATE_LOC = "BC")
#' }
#'
#'
station_report = function(output_type = "pdf", STATION_NUMBER = NULL, PROV_TERR_STATE_LOC = NULL){

  if(!output_type %in% c("pdf","html")){
    stop('output_type must be "pdf" or "html"')
  }

  rmarkdown::render(system.file("templates", "station_report.Rmd", package="hydrolook"),
                    output_format = paste0(output_type,"_document"),
                    params = list(
                      table_format = ifelse(output_type == "pdf","latex","html"),
                      stns = STATION_NUMBER,
                      prov = PROV_TERR_STATE_LOC),
                    output_file = paste0("STN_",STATION_NUMBER,"_",Sys.Date(),".",output_type),
                    output_dir = paste0("report/station_reports")
  )
}
