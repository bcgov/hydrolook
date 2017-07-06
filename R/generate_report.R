#' @export
#'
#' @title Generate diagnostic report
#'
#' @description run this command to render the Net_diag report. The reports are then outputted to the report folder


generate_report <- function() {

  rmarkdown::render(input = "vignettes/Net_diag.Rmd",
                    output_file = paste0("Net_diagnostic_",Sys.Date(),".html"),
                    output_dir = "report")

}
