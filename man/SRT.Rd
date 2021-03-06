% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SRT.R
\name{SRT}
\alias{SRT}
\title{SRT}
\usage{
SRT(
  dict = OSSAB::OSSAB_dict,
  item_bank = OSSAB::SRT_item_bank,
  languages = OSSAB::languages,
  timeout_in_msec = 20000,
  with_practice = TRUE,
  with_feedback = FALSE,
  label = "SRT"
)
}
\arguments{
\item{dict}{The psychTestR dictionary used for internationalisation.}

\item{item_bank}{The item_bank of test items used in the SRT.}

\item{languages}{(Character vector)
Determines the languages available to participants.
Possible languages include \code{"ru"} (Russian), and \code{"en"} (English).
The first language is selected by default.}

\item{timeout_in_msec}{Time in milliseconds until images of a test item disappear.
Defaults to 20000.}

\item{with_practice}{(Logical scalar) Whether to include the training phase.
Defaults to TRUE.}

\item{with_feedback}{(Logical scalar) Whether to display a feedback page.
Defaults to FALSE.}

\item{label}{(Character scalar) Label to give the SRT results in the output file.}
}
\description{
This function defines a SRT module for incorporation into a
psychTestR timeline.
Use this function if you want to include the SRT in a
battery of other tests, or if you want to add custom psychTestR
pages to your test timeline.
For a standalone implementation of the SRT,
consider using \code{\link{SRT_standalone}()}.
}
