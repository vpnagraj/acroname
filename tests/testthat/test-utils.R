test_that("first_char can extract first letter or number", {

  tst <- first_char("NOTHING")
  expect_equal(tst, "N")

  tst <- first_char("compares")
  expect_equal(tst, "c")

  tst <- first_char("2U")
  expect_equal(tst, "2")

})

test_that("find_articles works as expected", {

  tst <- find_articles("a")
  expect_true(tst)

  tst <- find_articles("AN")
  expect_true(tst)

  tst <- find_articles("The")
  expect_true(tst)

  tst <- find_articles("whatever")
  expect_true(!tst)

})
