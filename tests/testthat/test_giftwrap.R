context("giftwrap runs commands")

test_that("giftwrap captures output", {
  expect_equal(length(giftwrap("echo hey", process_echo = F)), 4)
  expect_equal(giftwrap("echo hey", process_echo = F)$status, 0)
  expect_equal(giftwrap("echo hey", process_echo = F)$stdout, "hey\n")
  expect_equal(giftwrap("echo hey", process_echo = F)$stderr, "")
})

test_that("giftwrap fails when command fails", {
  expect_error(giftwrap("absolutelyneveraclicommand", process_echo = F))
  expect_error(giftwrap("ls thisisnotarealdirectoryever", process_echo = F))
})

