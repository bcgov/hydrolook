context("Test function that checks if packages are installed")

test_that("check_package_installation returns a message when given missing packages",{
  expect_error(hydrolook:::check_package_installation(c("dplyr2", "ggplot3")))
})


test_that("check_package_installation is silent when given valid packages",{
  expect_silent(hydrolook:::check_package_installation(c("utils", "stats")))
})
