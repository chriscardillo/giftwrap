context("lexicon fetches lexicons")

test_that("unknown lexicons fail", {
  expect_error(lexicon("thisdoesnotexist"))
})

test_that("lexicons exist", {
  expect_true(any(class(lexicon("aws")) == "tbl"))
  expect_true(any(class(lexicon("az")) == "tbl"))
  expect_true(any(class(lexicon("brew")) == "tbl"))
  expect_true(any(class(lexicon("docker")) == "tbl"))
  expect_true(any(class(lexicon("gcloud")) == "tbl"))
  expect_true(any(class(lexicon("gh")) == "tbl"))
  expect_true(any(class(lexicon("git")) == "tbl")) 
  expect_true(any(class(lexicon("heroku")) == "tbl"))
  expect_true(any(class(lexicon("kubectl")) == "tbl"))
  expect_true(any(class(lexicon("sfdx")) == "tbl"))
})
