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
#' @param report_name Report to generate. Options:
#' \itemize{
#' \item Net_diag (not currently implemented)
#' \item Realtime_lag
#' }
#' @param province Province to be surveyed. Defaults to BC.
#' @param output_type the type of file to be outputted. Currently html and pdf are supported. defaults to pdf
#'
#' @description run this command to render the Net_diag report. The reports are then outputted to the report folder
#'
#' @examples
#' \dontrun{
#' generate_report(report_name = "Realtime_lag", output_type = "pdf", province = "PE")
#' }


generate_report <- function(report_name, output_type = "pdf", province = "BC") {

  if(!output_type %in% c("pdf","html")){
    stop('output_type must be "pdf" or "html"')
  }

  if(report_name == "Realtime_lag"){
    input_path = system.file("templates", "Realtime_lag.Rmd", package="hydrolook")
  }

  #if(report_name == "Net_diag"){
  #  input_path = system.file("templates", "Net_diag.Rmd", package="hydrolook")
  #}

  rmarkdown::render(input = input_path,
                    output_format = paste0(output_type,"_document"),
                    params = list(
                      table_format = ifelse(output_type == "pdf","latex","html"),
                      prov = province
                    ),
                    output_file = paste0(report_name,"_",province,"_",Sys.Date(),".",output_type),
                    output_dir = paste0("report/",report_name))

}
