# Copyright 2018 Province of British Columbia
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



create_namespace_check <- function(library_eval){

  if(!is.element(library_eval, utils::installed.packages()[,1])){
    stop(paste0(library_eval, " needs to be installed"), call. = FALSE)
  }

}


check_report_packages <- function(input_path){

  ## Read in raw rmarkdown file
  raw_rmarkdown <- readLines(input_path)

  ## Find the start and end of the package chunk
  start = which(raw_rmarkdown == "```{r packages, include=FALSE}")[1] + 1
  end   = which(raw_rmarkdown == "```")[1] - 1

  ## Clean so that it is just the names
  libs_needed <- gsub("\\)", "", gsub("library\\(","",raw_rmarkdown[start:end]))

  lapply(libs_needed, create_namespace_check)
}






