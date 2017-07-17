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
#' \item Net_diag
#' \item Realtime_lag
#' }
#'
#' @description run this command to render the Net_diag report. The reports are then outputted to the report folder
#'
#' @examples
#' \dontrun{
#' generate_report(report_name = "Net_diag")
#' }


generate_report <- function(report_name) {

  rmarkdown::render(input = paste0("vignettes/",report_name,".Rmd"),
                    output_file = paste0(report_name,Sys.Date(),".html"),
                    output_dir = "report")

}
