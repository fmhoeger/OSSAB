library(shiny)

options(shiny.error = browser)
debug_locally <- !grepl("shiny-server", getwd())


#' Standalone
#'
#' This function launches a standalone testing session for a given questionnaire.
#' This can be used for data collection, either in the laboratory or online.
#' @param label (Scalar character) Three uppercase letter acronym of the questionnaire.
#' @param dict The psychTestR dictionary used for internationalisation.
#' @param item_bank The item_bank of test items used in the PFT.
#' @param languages (Character vector)
#' Determines the languages available to participants.
#' Possible languages include \code{"ru"} (Russian), and \code{"en"} (English).
#' The first language is selected by default.
#' @param admin_password (Scalar character) Password for accessing the admin panel.
#' @param researcher_email (Scalar character)
#' If not \code{NULL}, this researcher's email address is displayed
#' at the bottom of the screen so that online participants can ask for help.
#' @param problems_info
#' Message to display at the bottom of the screen
#' with advice about what to do if a problem occurs.
#' The default value, "default", gives
#' a standard English message including the researcher's email (if provided).
#' Alternatively, the argument can be either
#' a) an unnamed character scalar providing a non-internationalised message,
#' b) a named character vector of internationalised messages with the names
#' corresponding to language codes,
#' c) a named list of HTML tag objects providing internationalised messages,
#' for example:
#' \code{list(en = shiny::tags$span("Problems? Send an email to ",
#'                                  shiny::tags$b("researcher@domain.org")),
#'            de = shiny::tags$span("Probleme? Schreibe eine E-Mail an ",
#'                                  shiny::tags$b("researcher@domain.org")))}.
#' @param validate_id (Character scalar or closure) Function for validating IDs or string "auto"
#' for default validation which means ID should consist only of alphanumeric characters.
#' @param with_feedback (Scalar boolean) Indicates if performance feedback will be given at the end
#' of the test. Defaults to TRUE.
#' @param with_practice (Boolean scalar) Defines whether instructions and training are included.
#' Defaults to TRUE.
#' @param ... Further arguments to be passed to \code{\link{standalone}()}.
#' @export
standalone <- function(label,
                       dict = OSSAB::OSSAB_dict,
                       item_bank,
                       languages = OSSAB::languages,
                       admin_password = "sirius",
                       researcher_email = "tsigeman.es@talantiuspeh.ru or lihanov.mv@talantiuspeh.ru",
                       problems_info = "default",
                       validate_id = "auto",
                       with_feedback = TRUE,
                       with_practice = TRUE,
                       ...) {
  elts <- c(
    psychTestR::new_timeline(
      psychTestR::get_p_id(
        prompt = psychTestR::i18n("ENTER_ID"),
        placeholder = paste(psychTestR::i18n("E.G."), "10492817"),
        button_text = psychTestR::i18n("CONTINUE"),
        validate = validate_p_id(validate_id)
      ),
      dict = dict
    ),
    # call the questionnaire
    get(label)(
      dict = dict,
      item_bank = item_bank,
      language = languages[1],
      with_practice = with_practice,
      with_feedback = with_feedback,
      ...
    ),
    psychTestR::elt_save_results_to_disk(complete = TRUE),
    psychTestR::new_timeline(psychTestR::final_page(
      shiny::p(
        psychTestR::i18n("RESULTS_SAVED"),
        psychTestR::i18n("CLOSE_BROWSER")
      )
    ), dict = dict)
  )

  shiny::addResourcePath("www", system.file("www", package = "OSSAB"))
  psychTestR::make_test(
    elts,
    opt = psychTestR::test_options(
      title = dict$translate(sprintf("%s_TITLE", label), languages[1]),
      admin_password = admin_password,
      researcher_email = researcher_email,
      problems_info = problems_info,
      demo = FALSE,
      languages = languages,
      logo = "www/images/sirius_logo.jpg",
      logo_width = "100px",
      logo_height = "auto"
    )
  )
}

#' MRT Standalone
#' This function launches a standalone testing session for the MRT questionnaire.
#' @param item_bank The item_bank of test items used in the MRT.
#' @param languages (Character vector)
#' Determines the languages available to participants.
#' Possible languages include \code{"ru"} (Russian), and \code{"en"} (English).
#' The first language is selected by default.
#' @param ... Further arguments to be passed to \code{\link{MRT_standalone}()}.
#' @export
MRT_standalone <-
    function(item_bank = OSSAB::MRT_item_bank, languages = OSSAB::languages, ...)
    standalone(label = "MRT", item_bank = item_bank, languages = languages, ...)

#' PFT Standalone
#' This function launches a standalone testing session for the PFT questionnaire.
#' @param item_bank The item_bank of test items used in the PFT.
#' @param languages (Character vector)
#' Determines the languages available to participants.
#' Possible languages include \code{"ru"} (Russian), and \code{"en"} (English).
#' The first language is selected by default.
#' @param ... Further arguments to be passed to \code{\link{PFT_standalone}()}.
#' @export
PFT_standalone <-
  function(item_bank = OSSAB::PFT_item_bank, languages = OSSAB::languages, ...)
    standalone(label = "PFT", item_bank = item_bank, languages = languages, ...)

#' PAT Standalone
#' This function launches a standalone testing session for the PAT questionnaire.
#' @param item_bank The item_bank of test items used in the PAT.
#' @param languages (Character vector)
#' Determines the languages available to participants.
#' Possible languages include \code{"ru"} (Russian), and \code{"en"} (English).
#' The first language is selected by default.
#' @param ... Further arguments to be passed to \code{\link{PAT_standalone}()}.
#' @export
PAT_standalone <-
  function(item_bank = OSSAB::PAT_item_bank, languages = OSSAB::languages, ...)
    standalone(label = "PAT", item_bank = item_bank, languages = languages, ...)

#' SRT Standalone
#' This function launches a standalone testing session for the SRT questionnaire.
#' @param item_bank The item_bank of test items used in the SRT.
#' @param languages (Character vector)
#' Determines the languages available to participants.
#' Possible languages include \code{"ru"} (Russian), and \code{"en"} (English).
#' The first language is selected by default.
#' @param ... Further arguments to be passed to \code{\link{SRT_standalone}()}.
#' @export
SRT_standalone <-
  function(item_bank = OSSAB::SRT_item_bank, languages = OSSAB::languages, ...)
    standalone(label = "SRT", item_bank = item_bank, languages = languages, ...)
