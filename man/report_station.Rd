% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_station.R
\name{report_station}
\alias{report_station}
\title{Station report generator}
\usage{
report_station(output_type = "pdf", STATION_NUMBER = NULL)
}
\arguments{
\item{output_type}{the type of file to be outputted. Currently html and pdf are supported. defaults to pdf}

\item{STATION_NUMBER}{Water Survey of Canada station number. No default.}
}
\value{
Will output a report to a report/station_report directory
}
\description{
Commands to generate reports
}
\examples{
\donttest{
report_station(output_type = "pdf", STATION_NUMBER = "08EB005")
report_station(output_type = "pdf", STATION_NUMBER = "08MF005")
report_station(output_type = "pdf", STATION_NUMBER = "07EA005")
}


}
\seealso{
Other report_generators: \code{\link{report_net_diagnostic}},
  \code{\link{report_regional_streamflow}}
}
