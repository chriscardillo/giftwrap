context("lexicon fetches lexicons")

test_that("unknown lexicons fail", {
  expect_error(lexicon("thisdoesnotexist"))
})

test_that("lexicons exist", {
  expect_true(class(lexicon("aws")) == "data.frame") 
  expect_true(class(lexicon("az")) == "data.frame")
  expect_true(class(lexicon("docker")) == "data.frame") 
  expect_true(class(lexicon("gcloud")) == "data.frame") 
  expect_true(class(lexicon("gh")) == "data.frame")
  expect_true(class(lexicon("git")) == "data.frame") 
  expect_true(class(lexicon("heroku")) == "data.frame") 
  expect_true(class(lexicon("kubectl")) == "data.frame")
  expect_true(class(lexicon("sfdx")) == "data.frame")
})