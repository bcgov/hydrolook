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
#' @param nr_region the natural resource region of British Columbia to focus report. See example for possible names.
#' @param output_type the type of file to be outputted. Currently html and pdf are supported. defaults to pdf
#'
#' @description run this command to render the net_diag report. The reports are then outputted to the report folder
#' @family report_generators
#' @examples
#' \dontrun{
#'
#' nr_region_names <- c("Cariboo Natural Resource Region", "Kootenay-Boundary Natural Resource Region",
#' "Northeast Natural Resource Region", "Omineca Natural Resource Region",
#' "Skeena Natural Resource Region", "South Coast Natural Resource Region",
#' "Thompson-Okanagan Natural Resource Region", "West Coast Natural Resource Region")
#'
#' report_regional_streamflow(output_type = "pdf", nr_region = nr_region_names[1])
#' report_regional_streamflow(output_type = "html", nr_region = "Omineca Natural Resource Region")
#' }


report_regional_streamflow <- function(output_type = "pdf", nr_region) {

  if(!output_type %in% c("pdf","html")){
    stop('output_type must be "pdf" or "html"')
  }

  input_path = system.file("templates", "regional_streamflow.Rmd", package="hydrolook")

  check_report_packages(input_path)

  dir_here <- file.path("report/regional_streamflow")

  if(!dir.exists(dir_here)){
    dir.create(dir_here, recursive = TRUE)
  }


  ## Render report
  rmarkdown::render(input = input_path,
                    output_format = paste0(output_type,"_document"),
                    intermediates_dir = dir_here,
                    params = list(
                      table_format = ifelse(output_type == "pdf","latex","html"),
                      region = nr_region
                    ),
                    output_file = paste0("regional_streamflow_",
                                         gsub(" Natural Resource Region","", nr_region),
                                              "_",Sys.Date(),".",output_type),
                    output_dir = dir_here)

}
