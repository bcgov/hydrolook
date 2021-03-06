% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_regional_streamflow.R
\name{report_regional_streamflow}
\alias{report_regional_streamflow}
\title{Generate regional report on common flow metrics}
\usage{
report_regional_streamflow(output_type = "pdf", nr_region)
}
\arguments{
\item{output_type}{the type of file to be outputted. Currently html and pdf are supported. defaults to pdf}

\item{nr_region}{the natural resource region of British Columbia to focus report. See example for possible names.}
}
\description{
run this command to render the net_diag report. The reports are then outputted to the report folder
}
\examples{
\dontrun{

nr_region_names <- c("Cariboo Natural Resource Region", "Kootenay-Boundary Natural Resource Region",
"Northeast Natural Resource Region", "Omineca Natural Resource Region",
"Skeena Natural Resource Region", "South Coast Natural Resource Region",
"Thompson-Okanagan Natural Resource Region", "West Coast Natural Resource Region")

report_regional_streamflow(output_type = "pdf", nr_region = nr_region_names[1])
report_regional_streamflow(output_type = "html", nr_region = "Omineca Natural Resource Region")
}
}
\seealso{
Other report_generators: \code{\link{report_net_diagnostic}},
  \code{\link{report_station}}
}
