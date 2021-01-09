#' Generate acronym from input string
#'
#' @param input Character vector with text to use as the input for the candidate
#' @param dictionary Character vector containing dictionary of terms from which acronym should be created; default is `NULL` and `hunspell` "en_us" dictionary will be used
#' @param acronym_length Number of characters in acronym; default is `3`
#' @param ignore_articles Boolean indicating whether or not articles should be ignored ; default is `TRUE`
#' @param timeout Number of seconds to spend trying to search the for an acronym; default is `60`
#' @param bow Boolean for whether or not a "bag of words" approach should be used for "input" vector; default is `FALSE`
#' @param bow_prop Given `bow = TRUE` this specifies the proportion of words to sample; ignored if `bow = FALSE`; default is `0.5`
#' @param to_tibble Boolean as to whether or not the result should be a `tibble`; default is `FALSE`
#'
#' @return
#'
#' If `to_tibble = FALSE` (default), then a character vector containing the acronym capitalized and the original string, with letters used in the acronym capitalized.
#'
#' If `to_tibble = TRUE`, then a `tibble` with the following columns:
#'
#' - **formatted**: The candidate acronym and string with letters used capitalized
#' - **prefix**: The candidate acronym
#' - **suffix**: Words used with letters in acronym capitalized
#' - **original**: The original string used to construct the acronym
#'
#' @export
#'
#' @md
#'
acronym <- function(input, dictionary = NULL, acronym_length = 3, ignore_articles = TRUE, timeout = 60, bow = FALSE, bow_prop = 0.5, to_tibble = FALSE) {

  ## default behavior is to use hunspell en_us
  if(is.null(dictionary)) {

    dictpath <- system.file("dict", "en_US.dic", package = "hunspell")
    stopifnot(file.exists(dictpath))

    dictionary <-
      dictpath %>%
      readr::read_lines() %>%
      grep("^[A-Z]", ., value = TRUE) %>%
      gsub("/[A-Z]*.", "", .) %>%
      tolower()
  }

  tmp <- process_input(input = input, ignore_articles = ignore_articles, bow = bow, bow_prop = bow_prop)

  ## get the index of the first character
  first_char_ind <- abs(tmp$words_len  - cumsum(tmp$words_len))  + 1

  ## inintially set all indicies low
  probs <- rep(0.1, nchar(tmp$collapsed))
  ## for first characters bump up probability that index will be selected much higher
  probs[first_char_ind] <- 0.9
  ## bump up weight of first letter ?!
  probs[1] <- 0.95

  ## use timeout with tryCatch
  ## if the processing takes longer than timeout then a message will be printed
  tryCatch({
     res <- R.utils::withTimeout({
      find_candidate(collapsed = tmp$collapsed,
                     acronym_length = acronym_length,
                     probs = probs,
                     dictionary = dictionary,
                     words_len = tmp$words_len)
    }, timeout = timeout)
  }, TimeoutException = function(ex) {
    message("Took too long ...")
  })

  if(to_tibble) {
    ## tibble from result elements
    res_tibble <-
      dplyr::tibble(
      formatted = res$formatted,
      prefix = res$prefix,
      suffix = res$suffix,
      original = paste0(tmp$words, collapse = " ")
    )
    return(res_tibble)
  } else {
    return(res$formatted)
  }

}


#' Generate initialism from input string
#'
#' @param input Character vector with text to use as the input for the candidate
#' @param ignore_articles Boolean indicating whether or not articles should be ignored ; default is `TRUE`
#' @param bow Boolean for whether or not a "bag of words" approach should be used for "input" vector; default is `FALSE`
#' @param bow_prop Given `bow = TRUE` this specifies the proportion of words to sample; ignored if `bow = FALSE`; default is `0.5`
#' @param to_tibble Boolean as to whether or not the result should be a `tibble`; default is `FALSE`
#'
#' @return
#' If `to_tibble = FALSE` (default), then a character vector containing the initialism capitalized and the original string, with letters used in the initialism capitalized.
#'
#' If `to_tibble = TRUE`, then a `tibble` with the following columns:
#'
#' - **formatted**: The initialism and string with letters used capitalized
#' - **prefix**: The initialism
#' - **suffix**: Words used with letters in initialism capitalized
#' - **original**: The original string used to construct the initialism
#'
#' @export
#'
#' @md
#'
#'
initialism <- function(input, ignore_articles = TRUE, bow = FALSE, bow_prop = 0.5, to_tibble = FALSE) {

  ## process input
  tmp <- process_input(input = input, ignore_articles = ignore_articles, bow = bow, bow_prop = bow_prop)

  ## get candidate prefix
  candidate <- paste0(toupper(tmp$first_chars), collapse = "")

  tmp_collapsed_split <-
    tmp$collapsed %>%
    strsplit(., split = "") %>%
    unlist(.)

  ## indices for first char
  ## get the index of the first character
  first_char_ind <- abs(tmp$words_len  - cumsum(tmp$words_len))  + 1

  ## now format the output to include the capitalized letter
  ## first force everything to be lower case
  tmp_collapsed_split <- tolower(tmp_collapsed_split)
  ## then make sure letters at first char indices are capitalized
  tmp_collapsed_split[first_char_ind] <- toupper(tmp_collapsed_split[first_char_ind])
  ## now need to split the words up again
  last_letter_ind <- cumsum(tmp$words_len)
  tmp_collapsed_split[last_letter_ind[-length(last_letter_ind)]] <- paste0(tmp_collapsed_split[last_letter_ind[-length(last_letter_ind)]], " ")
  name  <- paste0(tmp_collapsed_split, collapse = "")

  ## format with original
  formatted <- paste0(toupper(candidate), ": ", name)

  if(to_tibble) {
    ## tibble from result elements
    res_tibble <-
      dplyr::tibble(
        formatted = formatted,
        prefix = candidate,
        suffix = name,
        original = paste0(tmp$words, collapse = " ")
      )
    return(res_tibble)
  } else {
    return(formatted)
  }


}
