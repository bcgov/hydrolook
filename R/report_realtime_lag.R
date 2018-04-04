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


#' @title Generate diagnostic report
#'
#' @inheritParams report_net_diagnostic
#'
#' @description run this command to render the realtime report. The reports are then outputted to the report folder
#'
#' @examples
#' \dontrun{
#' realtime_lag_report(output_type = "pdf", PROV_TERR_STATE_LOC = "PE")
#' }
#' @export


realtime_lag_report <- function(output_type = "pdf", PROV_TERR_STATE_LOC = "BC") {

  if(!output_type %in% c("pdf","html")){
    stop('output_type must be "pdf" or "html"')
  }


  input_path = system.file("templates", "realtime_lag.Rmd", package="hydrolook")

  dir_here <- file.path("report/Realtime_lag")

  rmarkdown::render(input = input_path,
                    output_format = paste0(output_type,"_document"),
                    intermediates_dir = dir_here,
                    params = list(
                      table_format = ifelse(output_type == "pdf","latex","html"),
                      prov = PROV_TERR_STATE_LOC
                    ),
                    output_file = paste0("realtime_lag_",PROV_TERR_STATE_LOC,"_",Sys.Date(),".",output_type),
                    output_dir = dir_here
                    )
}
