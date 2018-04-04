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


check_package_installation <- function(libs_needed) {

  ## Logical vector of installation status
  pkgs <- vapply(libs_needed, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))

  ## Which packages are not installed
  pkgs <- pkgs[which(pkgs == FALSE)]

  ## Extract the names of the logical vector
  pkgs <- names(pkgs)

  ## Output a message
  if(any(pkgs %in% "ggplot2") == TRUE && any(getNamespaceExports("ggplot2") %in% "GeomSf")){
    message("Please install the development version of ggplot2 using the devtools package:")
    message('install.packages(devtools); devtools::install_github("tidyverse/ggplot2")')

    pkgs <- pkgs[which(!pkgs %in% "ggplot2")]
  }

  if(length(pkgs) > 0) {
    message("The ",paste0(pkgs, collapse = ", ")," package(s) need to be installed to run this report.")
    message("Paste the following into the console to install the missing packages: install.packages(c(",
            paste0(sprintf("'%s'", pkgs), collapse = ","),"))")
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

  check_package_installation(libs_needed)

}






