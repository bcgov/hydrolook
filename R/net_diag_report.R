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


#' @export
#'
#' @title Generate diagnostic report
#'
#' @param PROV_TERR_STATE_LOC Province to be surveyed. Defaults to BC.
#' @param output_type the type of file to be outputted. Currently html and pdf are supported. defaults to pdf
#'
#' @description run this command to render the net_diag report. The reports are then outputted to the report folder
#' @family report_generators
#' @examples
#' \dontrun{
#' net_diag_report(output_type = "pdf", PROV_TERR_STATE_LOC = "PE")
#' }


net_diag_report <- function(output_type = "pdf", PROV_TERR_STATE_LOC = "BC") {

  if(!output_type %in% c("pdf","html")){
    stop('output_type must be "pdf" or "html"')
  }

  input_path = system.file("templates", "net_diag.Rmd", package="hydrolook")

  dir_here <- here::here("report/net_diag_lag")

  rmarkdown::render(input = input_path,
                    output_format = paste0(output_type,"_document"),
                    intermediates_dir = dir_here,
                    params = list(
                      table_format = ifelse(output_type == "pdf","latex","html"),
                      prov = PROV_TERR_STATE_LOC
                    ),
                    output_file = paste0("net_diag_",PROV_TERR_STATE_LOC,"_",Sys.Date(),".",output_type),
                    output_dir = dir_here)

}
