context("temp_* functions write readable files")

csv <- temp_csv(mtcars)
rds <- temp_rds(mtcars)
txt <- temp_lines(mtcars)

test_that("files written with temp_ functions are loaded", {
  expect_true(any(class(readr::read_csv(csv)) == "data.frame"))
  expect_true(any(class(readr::read_rds(rds)) == "data.frame"))
  expect_true(!is.null(readr::read_lines(txt)))
})
