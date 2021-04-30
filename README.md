[![img](https://img.shields.io/badge/Lifecycle-Retired-d45500)](https://github.com/bcgov/repomountie/blob/master/doc/lifecycle-badges.md)
[![Travis build
status](https://travis-ci.org/bcgov/hydrolook.svg?branch=master)](https://travis-ci.org/bcgov/hydrolook)

<!-- README.md is generated from README.Rmd. Please edit that file -->

# hydrolook

The hydrolook package has been developed to provide a series
semi-automated reports in R on various facets of the Water Survey of
Canada hydrometric network. The project is under active development and
breaking changes may be made.

## Installation

You first need to install R and it is strongly recommend that you
install RStudio.

-   Install R from here: <https://cloud.r-project.org/>

-   Install RStudio from here:
    <https://www.rstudio.com/products/rstudio/download/#download>

To install the `hydrolook` package, you need to install the remotes
package then the `hydrolook` package:

``` r
install.packages("remotes")
remotes::install_github("bcgov/hydrolook")
```

Then to load the package you need to use the library command. It is
advised that you setup a dedicated directory to conduct your analysis as
several folders will be created as reports are generated. When you
install hydrolook, several other packages will be installed as well.
Each report will request other individual packages be installed. Please
follow the error messages outputted by R.

``` r
library(hydrolook)
```

## HYDAT download

To use most of the `hydrolook` package you will need the most recent
version of the HYDAT database. The sqlite3 version can be downloaded
using `tidyhydat` which should have been installed when you installed
hydrolook:

``` r
library(tidyhydat)
download_hydat()
```

## Example

This is a basic example of `hydrolook` usage. Reports are written in
rmarkdown format and are generated using report specific commands. For
example, if we wanted to generate the `net_diagnostic` report we could
use the following command:

``` r
report_realtime_lag(output_type = "pdf", PROV_TERR_STATE_LOC = "AB")
report_station(output_type = "pdf", STATION_NUMBER = "08MF005")
report_net_diagnostic(output_type = "pdf", PROV_TERR_STATE_LOC = "PE")
```

Or if an HTML output is desired, this can be modified with the
output_type argument:

``` r
report_net_diagnostic(output_type = "html", PROV_TERR_STATE_LOC = "PE")
```

## Project Status

This package is no longer maintained.

## Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an
[issue](https://github.com/bcgov/hydrolook/issues/).

## How to Contribute

If you would like to contribute to the package, please see our
[CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.

## License

    Copyright 2017 Province of British Columbia

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at 

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
