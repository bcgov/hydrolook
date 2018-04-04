# hydrolook 0.1.9
* added travis
* simplified net_diag report by using only basic tools; works with html and pdf
* better map for report_station
* general package tidying; removing many package dependencies
* station functions check and return an error if report packages aren't installed.
* removed the following functions: check_stn_gap.R, network_correlation.R
* addition of regional streamflow reports

# hydrolook 0.1.8
* Better identification of path through `here::here()`
* Fixes bug identified in #8; applied to all functions

# hydrolook 0.1.7
* Update to tidyhydat 0.3.1
* Add new network correlation plot function `network_correlation()`
* Update to bcmaps

# hydrolook 0.1.6
* fixed output bug for all reports
* updated docs

# hydrolook 0.1.5
* better percentile figure
* different arrange of figures


# hydrolook 0.1.4
* Three working functions for each report type
* Accept STATION_NUMBER/PROV_TERR_STATE_LOC as an argument

# hydrolook 0.1.2

* Passing all R CMD checks
* Still a very rudimentary package


# hydrolook 0.1.1

* Added a `NEWS.md` file to track changes to the package.
* Working realtime gap function that can accept province and file type as arguments.



