% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{find_candidate}
\alias{find_candidate}
\title{Find candidate}
\usage{
find_candidate(collapsed, acronym_length, probs, dictionary, words_len)
}
\arguments{
\item{collapsed}{The collapsed string of characters generated by \link[acroname]{mince}}

\item{acronym_length}{Number of characters in acronym; default is \code{3}}

\item{probs}{Vector of probabilities for selecting each character while generating candidate}

\item{dictionary}{Character vector containing dictionary of terms from which acronym should be created; default is \code{NULL} and \code{hunspell} "en_us" dictionary will be used}

\item{words_len}{Vector of the length of each word in the input}
}
\value{
Named list with three elements:
\itemize{
\item \strong{formatted}: The candidate acronym and string with letters used capitalized
\item \strong{prefix}: The candidate acronym
\item \strong{suffix}: Words used with letters in acronym capitalized
#'
}
}
\description{
This is an unexported helper for \link[acroname]{acronym}. The function is used wrapped in a \code{tryCatch()} that uses \link[R.utils]{withTimeout} to manage maximum wait time for the candidate acronym search.
}
