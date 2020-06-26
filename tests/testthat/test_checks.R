context("checks throw errors")

bad_lexicon <- data.frame(bad_col = "terrible")
dupe_lexicon <- data.frame(base = "aws",
                           command = "s3",
                           subcommand = "ls",
                           giftwrap_command = "aws s3 ls")
dupe_lexicon <- rbind(dupe_lexicon, dupe_lexicon)

test_that("function checks work", {
  expect_error(check_named(list(hey="dude", "yo")))
  expect_error(check_null("this"))
  expect_error(check_null(whatabout=NULL))
  expect_error(check_lexicon(bad_lexicon))
  expect_error(check_lexicon(dupe_lexicon))
  expect_error(check_lexicon_name("thisisnotincluded"))
})
