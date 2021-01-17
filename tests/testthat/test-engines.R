test_that("inititalism captures first chars", {

  tst <- initialism("the fox condemns the trap, not himself")
  expect_equal(tst, "FCTNH: Fox Condemns Trap Not Himself")

  tst <- initialism("the fox condemns the trap, not himself", ignore_articles = FALSE)
  expect_equal(tst, "TFCTTNH: The Fox Condemns The Trap Not Himself")

  tst <- initialism("Nothing compares 2 u")
  expect_equal(tst, "NC2U: Nothing Compares 2 U")

})
