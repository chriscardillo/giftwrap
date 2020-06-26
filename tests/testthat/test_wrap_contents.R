context("correct contents are passed to giftwrap from wrap_* functions")

cenv <- new.env()
wrap_commands(c("echo", shout="echo"),
              env = cenv)

test_that("giftwrap contents are correct", {
  expect_true(any(grepl(paste0("giftwrap\\('", "echo","',"), capture.output(cenv$echo))))
  expect_true(any(grepl(paste0("giftwrap\\('", "echo","',"), capture.output(cenv$shout))))
  expect_false(any(grepl(paste0("giftwrap\\('", "shout","',"), capture.output(cenv$echo))))
  expect_false(any(grepl(paste0("giftwrap\\('", "shout","',"), capture.output(cenv$shout))))
})
