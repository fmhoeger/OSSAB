library(shiny)
library(stringr)
library(tidyverse)

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
#' Possible languages include Russian (\code{"ru"}), and English (\code{"en"}).
#' The first language is selected by default.
#' @param admin_password (Scalar character) Password for accessing the admin panel.
#' @param researcher_email (Scalar character)
#' If not \code{NULL}, this researcher's email address is displayed
#' at the bottom of the screen so that online participants can ask for help.
#' @param validate_id (Character scalar or closure) Function for validating IDs or string "auto"
#' for default validation which means ID should consist only of alphanumeric characters.
#' @param with_feedback (Scalar boolean) Indicates if performance feedback will be given at the end
#' of the test. Defaults to TRUE.
#' @param with_practice (Boolean scalar) Defines whether instructions and training are included.
#' Defaults to TRUE.
#' @param ... Further arguments to be passed to \code{\link{standalone}()}.
#' @export
standalone <- function(label,
                       dict,
                       item_bank,
                       languages = c("ru", "en"),
                       admin_password = "sirius",
                       researcher_email = "tsigeman.es@talantiuspeh.ru or lihanov.mv@talantiuspeh.ru",
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
        validate = validate_id
      ),
      dict = dict
    ),
    # call the questionnaire
    get(label)(
      dict = dict,
      item_bank = item_bank,
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

  #version_info <- read.delim(system.file("extdata", "VERSION", package="psychSAT"), header = FALSE)
  shiny::addResourcePath("www", system.file("www", package = "psychSAT"))
  psychTestR::make_test(
    elts,
    opt = psychTestR::test_options(
      title = dict$translate(
        stringr::str_interp("TITLE"),
        languages[1]
      ),
      admin_password = admin_password,
      researcher_email = researcher_email,
      demo = FALSE,
      languages = languages#,
      #app_info = paste0("psychSAT v", toString(version_info$V1[1]))
    )
  )
}

#' MRT Standalone
#' This function launches a standalone testing session for the MRT questionnaire.
#' @param dict The psychTestR dictionary used for internationalisation.
#' @param item_bank The item_bank of test items used in the MRT.
#' @param languages (Character vector)
#' Determines the languages available to participants.
#' Possible languages include English (\code{"EN"}), and German (\code{"DE"}).
#' The first language is selected by default.
#' @param ... Further arguments to be passed to \code{\link{MRT_standalone}()}.
#' @export
MRT_standalone <-
  function(dict = psychSAT::MRT_dict, item_bank = psychSAT::MRT_item_bank, languages = c("ru", "en"), ...)
    standalone(label = "MRT", dict = dict, item_bank = item_bank, languages = languages, ...)

#' PFT Standalone
#' This function launches a standalone testing session for the PFT questionnaire.
#' @param dict The psychTestR dictionary used for internationalisation.
#' @param item_bank The item_bank of test items used in the PFT.
#' @param languages (Character vector)
#' Determines the languages available to participants.
#' Possible languages include English (\code{"EN"}), and German (\code{"DE"}).
#' The first language is selected by default.
#' @param ... Further arguments to be passed to \code{\link{PFT_standalone}()}.
#' @export
PFT_standalone <-
  function(dict = psychSAT::PFT_dict, item_bank = psychSAT::PFT_item_bank, languages = c("ru", "en"), ...)
    standalone(label = "PFT", dict = dict, item_bank = item_bank, languages = languages, ...)

#' PAT Standalone
#' This function launches a standalone testing session for the PAT questionnaire.
#' @param dict The psychTestR dictionary used for internationalisation.
#' @param item_bank The item_bank of test items used in the PAT.
#' @param languages (Character vector)
#' Determines the languages available to participants.
#' Possible languages include English (\code{"EN"}), and German (\code{"DE"}).
#' The first language is selected by default.
#' @param ... Further arguments to be passed to \code{\link{PAT_standalone}()}.
#' @export
PAT_standalone <-
  function(dict = psychSAT::PAT_dict, item_bank = psychSAT::PAT_item_bank, languages = c("ru", "en"), ...)
    standalone(label = "PAT", dict = dict, item_bank = item_bank, languages = languages, ...)

#' SRT Standalone
#' This function launches a standalone testing session for the SRT questionnaire.
#' @param dict The psychTestR dictionary used for internationalisation.
#' @param item_bank The item_bank of test items used in the SRT.
#' @param languages (Character vector)
#' Determines the languages available to participants.
#' Possible languages include English (\code{"EN"}), and German (\code{"DE"}).
#' The first language is selected by default.
#' @param ... Further arguments to be passed to \code{\link{SRT_standalone}()}.
#' @export
SRT_standalone <-
  function(dict = psychSAT::SRT_dict, item_bank = psychSAT::SRT_item_bank, languages = c("ru", "en"), ...)
    standalone(label = "SRT", dict = dict, item_bank = item_bank, languages = languages, ...)
