context("wrap_commands and wrap_lexicon generate commands")

other_env <- new.env()

wrap_commands("echo")
wrap_commands("echo", use_namespace = "gifts")
wrap_commands("echo", env = other_env)

wrap_lexicon(lexicon("git"),
             commands = "status")
wrap_lexicon(lexicon("git"),
             commands = "status",
             env = other_env)
wrap_lexicon(lexicon("aws"),
             commands = "s3$",
             subcommands = "ls$",
             use_namespace = "gifts",
             drop_base = T)

wrap_commands("fake commmand -f --flag option",
              env = other_env)

test_that("wrap_commands creates commands", {
  expect_true(!is.null(echo))
  expect_true(!is.null(other_env$echo))
  expect_true(!is.null(gifts::echo))
})

test_that("wrap_lexicon creates commands", {
  expect_true(!is.null(git_status))
  expect_true(!is.null(other_env$git_status))
})

test_that("wrap_lexicon drops base", {
  expect_true(!is.null(gifts::s3_ls))
})

test_that("wrap_commands errors work", {
  expect_error(wrap_commands("echo", env = ""))
})

test_that("wrap_commands accepts flags in wrapping", {
  expect_true(!is.null(other_env$fake_commmand_f_flag_option))
  expect_true(any(grepl("fake commmand -f --flag option", 
                        capture.output(other_env$fake_commmand_f_flag_option))))
})

