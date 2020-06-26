context("wrap_commands accepts arguments, lists, and vectors")

# arguments
aenv <- new.env()
wrap_commands("foo", "bar", biz="baz",
              env = aenv)

# list
lenv <- new.env()
wrap_commands(list("foo", "bar", biz="baz"),
              env = lenv)

# vector
venv <- new.env()
wrap_commands(c("foo", "bar", biz="baz"),
              env = venv)

# tests

test_that("wrap_commands handles arguments of different classes", {
  expect_true(!is.null(aenv$foo))
  expect_true(!is.null(aenv$bar))
  expect_true(!is.null(aenv$biz))
  expect_true(!is.null(lenv$foo))
  expect_true(!is.null(lenv$bar))
  expect_true(!is.null(lenv$biz))
  expect_true(!is.null(venv$foo))
  expect_true(!is.null(venv$bar))
  expect_true(!is.null(venv$biz))
})

test_that("wrap_commands rejects arguments of varying length", {
  expect_error(wrap_commands(c("foo", "biz"), "bar")) 
})
