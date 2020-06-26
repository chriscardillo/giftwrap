context("format_arg and format_args correctly format shell arguments")

test_that("format_arg conversions work", {
  expect_equal(format_arg(list("hey")), "hey")
  expect_equal(format_arg(list("-rf")), "-rf")
  expect_equal(format_arg(list("--recursive")), "--recursive")
  expect_equal(format_arg(list(m="hey")), c("-m", "hey"))
  expect_equal(format_arg(list(message="hey")), c("--message", "hey"))
  expect_equal(format_arg(list(message="")), "--message")
  expect_equal(format_arg(list(this_changes="")), "--this-changes")
  expect_equal(format_arg(list(message="multi word arg")), c("--message", "multi word arg"))
})

test_that("format_args conversions work", {
  expect_equal(format_args("hey"), "hey")
  expect_equal(format_args("-rf"), "-rf")
  expect_equal(format_args("--recursive"), "--recursive")
  expect_equal(format_args(m="hey"), c("-m", "hey"))
  expect_equal(format_args(message="hey"), c("--message", "hey"))
  expect_equal(format_args(message=""), "--message")
  expect_equal(format_args(this_changes=""), "--this-changes")
  expect_equal(format_args(message="multi word arg"), c("--message", "multi word arg"))
  expect_equal(format_args(a="first", a="second"), c("-a", "first", "-a", "second"))
  expect_equal(format_args(u="r", the="args", test_case=""), c("-u", "r", "--the", "args", "--test-case"))
})


test_that("format_arg errors work", {
  expect_error(format_arg("hey"))
})
