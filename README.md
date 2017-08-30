<a rel="Exploration" href="https://github.com/BCDevExchange/docs/blob/master/discussion/projectstates.md"><img alt="Being designed and built, but in the lab. May change, disappear, or be buggy." style="border-width:0" src="https://assets.bcdevexchange.org/images/badges/exploration.svg" title="Being designed and built, but in the lab. May change, disappear, or be buggy." /></a>

<!-- README.md is generated from README.Rmd. Please edit that file -->
hydrolook
=========

The hydrolook package has been developed to provide a series semi-automated reports on various facets of the Water Survey of Canada hydrometric network.

Installation
------------

To install the `hydrolook` package, you need to install the devtools package then both the `hydrolook` and `tidyhydat` package

``` r
install.packages("devtools")
devtools::install_github("bcgov/hydrolook")
devtools::install_github("bcgov/tidyhydat")
```

Then to load the package you need to use the library command. When you install hydrolook, several other packages will be installed as well. One of those packages, `dplyr`, is useful for data manipulations and is used regularly here. Even though `dplyr` is installed alongside `hydrolook`, you must still load it explicitly.

``` r
library(hydrolook)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

HYDAT download
--------------

To use most of the `hydrolook` package you will need the most recent version of the HYDAT database. The sqlite3 version can be downloaded here:

-   <http://collaboration.cmc.ec.gc.ca/cmc/hydrometrics/www/>

You will need to download that file, unzip it and put it somewhere on local storage. The path to the sqlite3 must be specified within each function that uses HYDAT. Or you can use the `download_hydat()` function from `tidyhydat`.

Example
-------

This is a basic example of `hydrolook` usage. Reports are written in rmarkdown format and are generated using `generate_report()`. For example, if we wanted to generate the Net\_diag report we could use the following command:

``` r
generate_report(report_name = "Net_diag") 

generate_report(report_name = "Realtime_lag")

station_report(STATION_NUMBER = "08MF005", PROV_TERR_STATE_LOC = "BC")
```

Check stn\_gap of all stations across Canada
--------------------------------------------

This will take about 20 minutes to run. This illustrates how `hydrolook` functionality can be extended.

``` r
start_time = Sys.time()
## Download all stations
stns <- tidyhydat::realtime_network_meta(PROV_TERR_STATE_LOC = "ALL")

## Create a vector of all PROV_TERR_STATE_LOC values
stns_loop_var <- unique(stns$PROV_TERR_STATE_LOC)

#stns_loop_var <- "PE"
lag_df <- c()
for (i in 1:length(stns_loop_var)) {
  cat(paste0(stns_loop_var[i], "\n"))
  
  u = check_realtime_lag(PROV_TERR_STATE_LOC = stns_loop_var[i])
  u$PROV_TERR_STATE_LOC = stns_loop_var[i]
  lag_df = dplyr::bind_rows(lag_df, u)
}

total_time = Sys.time() - start_time
```

Then you can plot the results across jurisdictions

``` r
lag_df %>%
  mutate(time_lag_h = as.double(time_lag, units= "hours")) %>%
  full_join(tidyhydat::realtime_network_meta(PROV_TERR_STATE_LOC = "ALL"), 
            by = c("STATION_NUMBER", "PROV_TERR_STATE_LOC")) %>%
  ggplot(aes(x = LONGITUDE, y = time_lag_h, colour = PROV_TERR_STATE_LOC)) +
  geom_point() +
  facet_wrap(~PROV_TERR_STATE_LOC, scales = "free_x")


lag_df %>%
  mutate(time_lag_h = as.double(time_lag, units= "hours")) %>%
  full_join(tidyhydat::realtime_network_meta(PROV_TERR_STATE_LOC = "ALL"), 
            by = c("STATION_NUMBER", "PROV_TERR_STATE_LOC")) %>%
  ggplot(aes(x  = time_lag_h)) +
  geom_histogram(binwidth = 1) +
  geom_rug() +
  facet_wrap(~PROV_TERR_STATE_LOC)
```

Project Status
--------------

This package is under continual development.

Getting Help or Reporting an Issue
----------------------------------

To report bugs/issues/feature requests, please file an [issue](https://github.com/bcgov/hydrolook/issues/).

How to Contribute
-----------------

If you would like to contribute to the package, please see our [CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

License
-------

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
