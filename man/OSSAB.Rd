% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/OSSAB.R
\name{OSSAB}
\alias{OSSAB}
\title{OSSAB battery}
\usage{
OSSAB(
  title = "",
  tests = c(MRT, PAT, PFT, SRT),
  languages = OSSAB::languages,
  dict = OSSAB::OSSAB_dict,
  admin_password = "sirius",
  researcher_email = "tsigeman.es@talantiuspeh.ru or lihanov.mv@talantiuspeh.ru",
  problems_info = "default",
  with_practice = TRUE,
  with_feedback = TRUE,
  validate_id = "auto",
  ...
)
}
\arguments{
\item{title}{(Character scalar) Title of the test battery to be displayed at the top of the page.}

\item{tests}{(Vector of test functions) The tests to be included in the battery.
Possible values are MRT, PAT, PFT, and SRT.
Example: \code{OSSAB(tests = c(MRT, PFT), languages = "en")}.
Defaults to \code{c(MRT, PAT, PFT, SRT)}.}

\item{languages}{(Character vector)
Determines the languages available to participants.
Possible languages include \code{"ru"} (Russian), and \code{"en"} (English).
The first language is selected by default.}

\item{dict}{(i18n_dict) The psyquest dictionary used for internationalisation.}

\item{admin_password}{(Character scalar) Password to access the admin panel.}

\item{researcher_email}{(Character scalar) Researcher's email; used in participant help message.}

\item{problems_info}{Message to display at the bottom of the screen
with advice about what to do if a problem occurs.
The default value, "default", gives
a standard English message including the researcher's email (if provided).
Alternatively, the argument can be either
a) an unnamed character scalar providing a non-internationalised message,
b) a named character vector of internationalised messages with the names
corresponding to language codes,
c) a named list of HTML tag objects providing internationalised messages,
for example:
\code{list(en = shiny::tags$span("Problems? Send an email to ",
                                 shiny::tags$b("researcher@domain.org")),
           de = shiny::tags$span("Probleme? Schreibe eine E-Mail an ",
                                 shiny::tags$b("researcher@domain.org")))}.}

\item{with_practice}{(Logical scalar) Whether to include the training phase.
Defaults to TRUE.}

\item{with_feedback}{(Logical scalar) Whether to display a feedback page.
Defaults to TRUE.}

\item{validate_id}{(Character scalar or closure) Function for validating IDs or string "auto"
for default validation which means ID should consist only of alphanumeric characters.}

\item{...}{Further arguments to be passed to \code{\link{OSSAB}()}.}
}
\description{
This function defines the OSSAB battery.
Use this function if you want to create a battery of tests.
}
