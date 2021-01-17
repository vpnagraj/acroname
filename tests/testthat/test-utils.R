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

test_that("mince works as expected with defaults", {

  tst <- mince("the fox condemns the trap, not himself")

  expect_equal(tst$words, c("fox", "condemns", "trap", "not", "himself"))
  expect_equal(tst$collapsed, "foxcondemnstrapnothimself")
  expect_equal(tst$words_len, c(3,8,4,3,7))
  expect_equal(tst$first_chars, c("f","c","t","n","h"))

})

test_that("mince works with articles", {

  tst <- mince("the fox condemns the trap, not himself", ignore_articles = FALSE)

  expect_equal(tst$words, c("the","fox", "condemns", "the", "trap", "not", "himself"))
  expect_equal(tst$collapsed, "thefoxcondemnsthetrapnothimself")
  expect_equal(tst$words_len, c(3,3,8,3,4,3,7))
  expect_equal(tst$first_chars, c("t","f","c","t","t","n","h"))

})


test_that("mince works with non-alphanumeric", {

  tst <- mince("the fox condemns the trap, not himself", alnum_only = FALSE, ignore_articles = FALSE)

  expect_equal(tst$words, c("the","fox", "condemns", "the", "trap,", "not", "himself"))
  expect_equal(tst$collapsed, "thefoxcondemnsthetrap,nothimself")
  expect_equal(tst$words_len, c(3,3,8,3,5,3,7))
  expect_equal(tst$first_chars, c("t","f","c","t","t","n","h"))

})
